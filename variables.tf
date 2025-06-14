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
