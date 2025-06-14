#!/bin/bash

# constants definition
FEDORA_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
ALMA_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
ROCKY_URL="https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"

FEDORA_IMAGE="Fedora-Cloud-42_x86_64.qcow2"
ALMA_IMAGE="AlmaLinux-Cloud-9_x86_64.qcow2"
ROCKY_IMAGE="Rocky-Cloud-10_x86_64.qcow2"

IMAGES=("$FEDORA_IMAGE" "$ALMA_IMAGE" "$ROCKY_IMAGE")

ROOT_DIR=$(git rev-parse --show-toplevel)
pushd "$ROOT_DIR" > /dev/null

mkdir -p images ; pushd images > /dev/null

# Fedora
if [ ! -f "$FEDORA_IMAGE" ]; then
    echo "Downloading Fedora image..."
    wget -q "$FEDORA_URL" -O "$FEDORA_IMAGE"
else
    echo "$FEDORA_IMAGE already exists, skipping download."
fi
# Alma
if [ ! -f "$ALMA_IMAGE" ]; then
    echo "Downloading AlmaLinux image..."
    wget -q "$ALMA_URL" -O "$ALMA_IMAGE"
else
    echo "$ALMA_IMAGE already exists, skipping download."
fi
# Rocky
if [ ! -f "$ROCKY_IMAGE" ]; then
    echo "Downloading Rocky Linux image..."
    wget -q "$ROCKY_URL" -O "$ROCKY_IMAGE"
else
    echo "$ROCKY_IMAGE already exists, skipping download."
fi

# Returun to the start directory
popd > /dev/null ; popd > /dev/null


