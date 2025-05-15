[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin <DEVICE_USER> --noclear %I "$TERM"
Type=idle