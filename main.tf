locals {
  modulepath = "./modules/${var.target}"
}

module "target_provisioner" {
  source = local.modulepath
  # Pass all the variables to the module
  distro = var.distro
  ssh_key = var.ssh_key
  vm_count = var.vm_count
  vm_subnet = var.vm_subnet
  vm_starting_ip = var.vm_starting_ip
  n_cores_per_vm = var.n_cores_per_vm
  memory_per_vm = var.memory_per_vm
  vm_disk_size = var.vm_disk_size
  network_domain = var.network_domain
  proxmox_n_sockets_per_vm = var.proxmox_n_sockets_per_vm
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_api_token = var.proxmox_api_token
  proxmox_ssh_agent_username = var.proxmox_ssh_agent_username
  proxmox_target_node_name = var.proxmox_target_node_name
  proxmox_template_id = var.proxmox_template_id
  proxmox_VM_id_start = var.proxmox_VM_id_start
  proxmox_vm_tag = var.proxmox_vm_tag
  proxmox_config_datastore_id = var.proxmox_config_datastore_id
  proxmox_vm_datastore_id = var.proxmox_vm_datastore_id
  proxmox_network_bridge_name = var.proxmox_network_bridge_name
  proxmox_network_interface_model = var.proxmox_network_interface_model
  proxmox_vm_disk_interface = var.proxmox_vm_disk_interface
}
