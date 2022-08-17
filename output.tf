output "public_ip_address" {
  description = "PIP address to Connect to CE"
  value       = azurerm_public_ip.pip.*.ip_address
}

output "private_ip_address" {
  description = "IP address to Connect to CE"
  value       = azurerm_network_interface.nic.*.private_ip_addresses
}
