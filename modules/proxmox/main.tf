terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = var.proxmox_ssh_agent_username
  }
}

locals {
  vm_prefix = "${var.distro}-vm"
}

resource "proxmox_virtual_environment_file" "cloud_user_config" {
  count         = var.vm_count
  content_type  = "snippets"
  datastore_id  = "local"  # TODO - make this configurable
  node_name     = "pve01"      # TODO - make this configurable

  source_raw {
    data = templatefile("${path.root}/cloud_init/proxmox/cloud_init.cfg", {
      ipaddr   = "192.168.1.${count.index + 230}"  # TODO - make this configurable
      ssh_key  = var.ssh_key
      hostname = "${local.vm_prefix}-${count.index}"
    })
    file_name = "${local.vm_prefix}-${count.index}-user_data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  count        = var.vm_count
  name         = "${local.vm_prefix}-${count.index}"
  vm_id        = 200 + count.index
  node_name    = "pve01"  # TODO - make this configurable
  tags         = ["tofu", "devel"]  # TODO - make this configurable
  started      = true

  clone {
    vm_id = 8002  # TODO - make this configurable
  }

  cpu {
    type    = "host"
    cores   = 1  # TODO - make this configurable
    sockets = 1  # TODO - make this configurable
  }

  memory {
    dedicated = 1024  # TODO - make this configurable
  }

  disk {
    interface    = "scsi0"
    size         = 10
    datastore_id = "local-lvm"  # TODO - make this configurable
  }

  network_device {
    bridge = "vmbr0"  # TODO - make this configurable
    model  = "virtio"
  }

  initialization {
    datastore_id = "local-lvm"  # TODO - make this configurable
    interface     = "ide2"

    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config[count.index].id

    ip_config {
      ipv4 {
        address = "192.168.1.${count.index + 230}/24"  # TODO - make this configurable
      }
    }

    dns {
      domain = "tofu.local"  # TODO - make this configurable
    }
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [vm_id]
  }
}
