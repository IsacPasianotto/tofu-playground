terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# TODO -> check this
# Added there because variables.tf wasn't support variables like ${path.root}
locals {
  image_map = {
    alma   = "${path.root}/images/AlmaLinux-Cloud-9_x86_64.qcow2"
    fedora = "${path.root}/images/Fedora-Cloud-42_x86_64.qcow2"
    rocky  = "${path.root}/images/Rocky-Cloud-10_x86_64.qcow2"
  }

  # Simple hostname prefix
  vm_prefix = "${var.distro}-vm"
}

# Create separate volumes for each VM
resource "libvirt_volume" "vm_disk" {
  count  = var.vm_count
  name   = "${local.vm_prefix}-${count.index}.qcow2"
  source = local.image_map[var.distro]
  format = "qcow2"
  pool   = "default"
}

# Cloud-init ISO
resource "libvirt_cloudinit_disk" "cloudinit" {
  count = var.vm_count
  name  = "cloudinit-${count.index}.iso"

  user_data = templatefile("${path.root}/cloud_init/libvirt/cloud_init.cfg", {
    ipaddr   = "${var.vm_subnet}.${var.vm_starting_ip + count.index}"
    ssh_key  = var.ssh_key
    hostname = "${local.vm_prefix}-${count.index}"
    subnet   = var.vm_subnet
  })

  pool = "default"
}

# Define the NAT network
resource "libvirt_network" "tofu_devel" {
  name      = "TOFU-devel"
  mode      = "nat"
  domain    = var.network_domain
  addresses = ["${var.vm_subnet}.0/24"]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }
}

# Define each VM
resource "libvirt_domain" "vm" {
  count  = var.vm_count
  name   = "${local.vm_prefix}-${count.index}"
  memory = var.memory_per_vm
  vcpu   = var.n_cores_per_vm
  arch   = "x86_64"
  autostart = true

  # Needed, otherwise alma and rocky will not boot and goes in kernel panic.
  # See: https://blog.thetechcorner.sk/posts/Quick-fix-AlmaLinux9-cloud-init-kernel-panic/
  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }

  network_interface {
    network_name   = libvirt_network.tofu_devel.name
    wait_for_lease = true
    hostname       = "${local.vm_prefix}-${count.index}"
    addresses      = ["${var.vm_subnet}.${var.vm_starting_ip + count.index}"]
  }
  cloudinit = libvirt_cloudinit_disk.cloudinit[count.index].id
}
