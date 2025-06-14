# Output the assigned IPs
output "vm_ips" {
  value = libvirt_domain.vm[*].network_interface[0].addresses
}
