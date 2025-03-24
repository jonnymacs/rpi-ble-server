#!/bin/bash

set -eu

BINARY_BUILD_SVC="ble_server"
BINARY_NAME="ble_server"
RPI_BUILD_SVC="macmind_rpi_ble_server"
RPI_BUILD_USER="imagegen"
RPI_CUSTOMIZATIONS_DIR="macmind_rpi_ble_server"
RPI_IMAGE_NAME="macmind_rpi_ble_server"

# build the ble server binary
# and copy it to the imagegen_ext_dir
# for the raspberry pi image build
#
docker compose build ${BINARY_BUILD_SVC}

docker compose run -d ${BINARY_BUILD_SVC} \
  && docker compose exec ${BINARY_BUILD_SVC} bash -c "cargo build --release --target aarch64-unknown-linux-gnu" \
  && docker ps -a --format '{{.Names}}' | grep ${BINARY_BUILD_SVC} | xargs -I '{}' -- docker cp {}:/app/target/aarch64-unknown-linux-gnu/release/${BINARY_NAME} ./${RPI_CUSTOMIZATIONS_DIR}/ext_dir/image/mbr/simple_dual/device/rootfs-overlay/usr/local/bin/${BINARY_NAME} \
  && docker compose kill ${BINARY_BUILD_SVC} \
  && docker ps -a --format '{{.Names}}' | grep ${BINARY_BUILD_SVC} | xargs -I '{}' -- docker rm {}

# Build a customer raspberry pi image
# with the ble server included
#
docker compose build ${RPI_BUILD_SVC}

docker compose run -d ${RPI_BUILD_SVC} \
  && docker compose exec ${RPI_BUILD_SVC} bash -c "/home/${RPI_BUILD_USER}/rpi-image-gen/build.sh -D /home/${RPI_BUILD_USER}/${RPI_CUSTOMIZATIONS_DIR}/ext_dir -c ${RPI_IMAGE_NAME} -o /home/${RPI_BUILD_USER}/${RPI_CUSTOMIZATIONS_DIR}/ext_dir/${RPI_IMAGE_NAME}.options" \
  && docker ps -a --format '{{.Names}}' | grep ${RPI_BUILD_SVC} | xargs -I '{}' -- docker cp {}:/home/${RPI_BUILD_USER}/rpi-image-gen/work/${RPI_IMAGE_NAME}/deploy/${RPI_IMAGE_NAME}.img .${RPI_CUSTOMIZATIONS_DIR}/deploy/${RPI_IMAGE_NAME}-$(date +%m-%d-%Y-%H%M).img \
  && docker compose kill ${RPI_BUILD_SVC} \
  && docker ps -a --format '{{.Names}}' | grep ${RPI_BUILD_SVC} | xargs -I '{}' -- docker rm {}