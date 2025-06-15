#!/bin/bash

##
##  -- Start of constants definition --
##

FEDORA_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
ALMA_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
ROCKY_URL="https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"

FEDORA_IMAGE="Fedora-Cloud-42_x86_64.qcow2"
ALMA_IMAGE="AlmaLinux-Cloud-9_x86_64.qcow2"
ROCKY_IMAGE="Rocky-Cloud-10_x86_64.qcow2"

FEDORA_TEMPLATE_NUMBER="8000"
ALMA_TEMPLATE_NUMBER="8001"
ROCKY_TEMPLATE_NUMBER="8002"

FEDORA_TEMPLATE_NAME="Fedora42-tofu-template"
ALMA_TEMPLATE_NAME="Alma9-tofu-template"
ROCKY_TEMPLATE_NAME="Rocky10-tofu-template"

##
##  -- End of constants definition --
##


# see Proxmox documentation for more details
WORKDIR='/var/lib/vz/template/iso'
pushd "$WORKDIR" > /dev/null

function image_present() {
    local image_name="$1"
    local image_url="$2"
    if [ ! -f "$image_name" ]; then
        echo "Downloading $image_name..."
        wget -q "$image_url" -O "$image_name"
    else
        echo "$image_name already exists, skipping download."
    fi
}

image_present "$FEDORA_IMAGE" "$FEDORA_URL"
image_present "$ALMA_IMAGE" "$ALMA_URL"
image_present "$ROCKY_IMAGE" "$ROCKY_URL"


function create_template() {
    local image_name="$1"
    local template_number="$2"
    local template_name="$3"
    if ! qm list | grep -q "$template_number"; then
        echo "Creating templateo$template_name from $image_name..."
        qm create $template_number --name "$template_name" --memory 512 --cores 1 --net0 virtio,bridge=vmbr0
        qm importdisk $template_number "$image_name" local-lvm
        qm set $template_number --tags "template,tofu"
        qm set $template_number --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$template_number-disk-0
        qm set $template_number --boot c --bootdisk scsi0
        qm set $template_number --ide2 local:cloudinit
        qm set $template_number --serial0 socket --vga serial0
        qm set $template_number --agent enabled=1
        qm template $template_number
    else
        echo "Template $template_name already exists, skipping creation."
    fi
}

create_template "$FEDORA_IMAGE" "$FEDORA_TEMPLATE_NUMBER" "$FEDORA_TEMPLATE_NAME"
create_template "$ALMA_IMAGE" "$ALMA_TEMPLATE_NUMBER" "$ALMA_TEMPLATE_NAME"
create_template "$ROCKY_IMAGE" "$ROCKY_TEMPLATE_NUMBER" "$ROCKY_TEMPLATE_NAME"

popd > /dev/null
