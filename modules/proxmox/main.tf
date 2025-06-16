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
  datastore_id  = var.proxmox_config_datastore_id
  node_name     = var.proxmox_target_node_name

  source_raw {
    data = templatefile("${path.root}/cloud_init/proxmox/cloud_init.cfg", {
      ipaddr   = "${var.vm_subnet}.${var.vm_starting_ip + count.index}"
      ssh_key  = var.ssh_key
      hostname = "${local.vm_prefix}-${count.index}"
      subnet   = var.vm_subnet
    })
    file_name = "${local.vm_prefix}-${count.index}-user_data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  count        = var.vm_count
  name         = "${local.vm_prefix}-${count.index}"
  vm_id        = 200 + count.index
  node_name    = var.proxmox_target_node_name
  tags         = var.proxmox_vm_tags
  started      = true

  clone {
    vm_id = var.proxmox_template_id
  }

  cpu {
    type    = "host"
    cores   = var.n_cores_per_vm
    sockets = 1 var.proxmox_n_sockets_per_vm
  }

  memory {
    dedicated = var.memory_per_vm
  }

  disk {
    interface    = var.proxmox_vm_disk_interface
    size         = var.vm_disk_size
    datastore_id = var.proxmox_config_datastore_id
  }

  network_device {
    bridge = var.proxmox_network_bridge_name
    model  = var.proxmox_network_interface_model
  }

  initialization {
    datastore_id = var.proxmox_config_datastore_id
    interface     = "ide2"

    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config[count.index].id

    ip_config {
      ipv4 {
        address = "${var.vm_subnet}.${var.vm_starting_ip + count.index}/24"
      }
    }

    dns {
      domain = var.network_domain
    }
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [vm_id]
  }
}
