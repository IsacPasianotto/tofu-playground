locals {
  modulepath = "./modules/${var.target}"
}

module "target_provisioner" {
  source = local.modulepath
  # Pass all the variables to the module
  vm_count     = var.vm_count
  distro       = var.distro
  ssh_key      = var.ssh_key
  # Proxmox specific variables, only used if target is 'proxmox'
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_api_token = var.proxmox_api_token
  proxmox_ssh_agent_username = var.proxmox_ssh_agent_username
  proxmox_target_node_name = var.proxmox_target_node_name
  proxmox_template_id = var.proxmox_template_id
  proxmox_VM_id_start = var.proxmox_VM_id_start
  proxmox_vm_tag = var.proxmox_vm_tag
}
