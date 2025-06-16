variable "target" {
  type = string
  description = "Choose 'libvirt' or 'proxmox'"
  default = "libvirt"
}

variable "vm_count" {
  type = number
  description = "Number of VMs to create"
  default = 2
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

#
# Proxmox specific variables
#

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
  type = string
  description = "Tag to apply to Proxmox VMs"
  default = "tofu"
}
