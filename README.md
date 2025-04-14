# rpi-ble-server

Build a bluetooth low enery service for a Raspberry Pi.

Build images to compile the ble server - written in Rust, and an
image to run rpi-image gen to build a raspberry pi image

This has been tested on both ARM64 Mac and AMD64 Mac laptops.

AMD is much slower as expected due to emulation.

clone this repository and run the build script

```sh
git clone https://github.com/jonnymacs/rpi-ble-server
cd rpi-ble-server
./build.sh
```

Use the Raspberry Pi Imager tool to install the img file located in macmind_rpi_ble_server/deploy
on an SD card or USB stick

[![Watch and Like the recorded video for this project on YouTube](https://img.youtube.com/vi/L8ZH9zQwcY8/maxresdefault.jpg)](https://www.youtube.com/watch?v=L8ZH9zQwcY8)

**[Watch and Like the recorded video for this project on YouTube](https://www.youtube.com/watch?v=L8ZH9zQwcY8)** 

**[Subscribe to the channel for more similar content](https://www.youtube.com/@macmind-io?sub_confirmation=1)

Please refer to https://github.com/raspberrypi/rpi-image-gen for more information rpi-image-gen

[Follow me on X](https://x.com/jonnymacs), and don't forget to star [this GitHub repository](https://github.com/jonnymacs/rpi_ble_server)!
