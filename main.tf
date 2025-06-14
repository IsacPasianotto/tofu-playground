locals {
  modulepath = "./modules/${var.target}"
}

module "target_provisioner" {
  source = local.modulepath
  # Pass all the variables to the module
  vm_count     = var.vm_count
  distro       = var.distro
  ssh_key      = var.ssh_key
}
