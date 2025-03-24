#!/bin/bash

set -eu

ROOTFS=$1

# configure autologin
sudo mkdir -p ${ROOTFS}/etc/systemd/system/getty@tty1.service.d
sudo /bin/sh -c "cat > ${ROOTFS}/etc/systemd/system/getty@tty1.service.d/override.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin macmind --noclear %I \"\$TERM\"
Type=idle
EOF"

# enable bluetooth on boot
sudo /bin/sh -c "cat > ${ROOTFS}/lib/systemd/system/unblock-bluetooth.service <<'EOF'
[Unit]
Description=Unblock Bluetooth at boot
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/rfkill unblock bluetooth
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF"
sudo chmod 644 ${ROOTFS}/lib/systemd/system/unblock-bluetooth.service
sudo ln -sf ${ROOTFS}/lib/systemd/system/unblock-bluetooth.service ${ROOTFS}/etc/systemd/system/multi-user.target.wants/unblock-bluetooth.service

# configure the BLE server to run on boot
sudo /bin/sh -c "cat > ${ROOTFS}/lib/systemd/system/ble-server.service <<'EOF'
[Unit]
Description=BLE Server for Setting System Time
After=network.target bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/usr/local/bin/ble_server
Restart=always
RestartSec=5
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF"
sudo chmod 644 ${ROOTFS}/lib/systemd/system/ble-server.service
sudo ln -sf ${ROOTFS}/lib/systemd/system/ble-server.service ${ROOTFS}/etc/systemd/system/multi-user.target.wants/ble-server.service

# rename the bluetooth service
sudo /bin/sh -c "cat > ${ROOTFS}/etc/machine-info <<'EOF'
PRETTY_HOSTNAME=SetRPITimeBLEServer
EOF"
