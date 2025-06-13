variable "ssh_key" {
  description = "Public SSH key to inject into the VM"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to provision"
  type        = number
  default     = 1
}

variable "distro" {
  description = "Distribution to use (alma, fedora, rocky)"
  type        = string
  default     = "alma"

  validation {
    condition     = contains(["alma", "fedora", "rocky"], var.distro)
    error_message = "Supported distros are: alma, fedora, rocky."
  }
}
