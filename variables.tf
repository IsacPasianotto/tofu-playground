variable "target" {
  type = string
  description = "Choose 'libvirt' or 'proxmox'"
  default = "libvirt"
}

variable "distro" {
  type = string
  description = "Linux distribution to use for the VMs among 'alma', 'fedora' and 'rocky'."
  default = "alma"
}

variable "ssh_key" {
  description = "SSH public key to use for VM access, required."
  type = string
}

##
## VM general settings
##

variable "vm_count" {
  type = number
  description = "Number of VMs to create"
  default = 2
}

variable "vm_subnet" {
  type = string
  description = "Subnet for the VMs, e.g., 192.168.1"
  default = "192.168.1"
}

variable "vm_starting_ip" {
  type = string
  description = "Starting IP address for the deployed VM, the other will be incremented by 1."
  default = "230"
}

variable "n_cores_per_vm" {
  type = number
  description = "Number of CPU cores per VM"
  default = 1
}

variable "memory_per_vm" {
  type = number
  description = "Memory size in MB for each VM"
  default = 1024
}

variable "vm_disk_size" {
  type = number
  description = "Disk size in GB for each VM"
  default = 10
}

variable "network_domain" {
  type = string
  description = "Network domain for the VMs, e.g., 'tofu.local'"
  default = "tofu.local"
}

#
# Proxmox specific variables
#

variable "proxmox_n_sockets_per_vm" {
  type = number
  description = "Number of CPU sockets usable per VM in Proxmox"
  default = 1
}

variable "proxmox_endpoint" {
  type = string
  description = "Proxmox API endpoint, e.g., 'https://proxmox.example.com:8006/"
}

variable "proxmox_api_token" {
  type = string
  description = "Proxmox API token in the format '<user@realm>!<token_name>=<token_value>'"
}

variable "proxmox_ssh_agent_username" {
  type = string
  description = "Username for SSH agent authentication in Proxmox"
  default = "root"
}

variable "proxmox_target_node_name" {
  type = string
  description = "Proxmox target node name where VMs will be created"
  default = "pve01"
}

variable "proxmox_template_id" {
  type = number
  description = "Proxmox template ID cloned during VM creation"
}

variable "proxmox_VM_id_start" {
  type = number
  description = "Starting VM ID for Proxmox VMs"
  default = 100
}

variable "proxmox_vm_tag" {
  type = list(string)
  description = "Tag to apply to Proxmox VMs"
  default = ["tofu", "devel"]
}


variable "proxmox_config_datastore_id" {
  type = string
  description = "Proxmox datastore ID for VM configuration files"
  default = "local"
}

variable "proxmox_vm_datastore_id" {
  type = string
  description = "Proxmox datastore ID for VM disks"
  default = "local-lvm"
}

variable "proxmox_network_bridge_name" {
  type = string
  description = "Proxmox network bridge name for VM networking"
  default = "vmbr0"
}

variable "proxmox_network_interface_model" {
  type = string
  description = "Proxmox network interface model for VMs"
  default = "virtio"
}

variable "proxmox_vm_disk_interface" {
  type = string
  description = "Proxmox disk interface type for VMs"
  default = "scsi0"
}
