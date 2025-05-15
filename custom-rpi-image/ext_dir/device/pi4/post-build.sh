# Enable the i2c modules
# This is needed for the i2c interface to work
# on the Raspberry Pi
cat <<EOF > $1/etc/modules
# Load the following modules at boot time
i2c-dev
i2c-bcm2835
EOF