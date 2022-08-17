locals {
  #Governance tags
  commonTags = {
    environment    = "${var.env_prefix}"
  }
  #NSG Rules for the nic
  rules = {

    ssh = {
      name                       = "Allow_Admin_SSH_Access"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefixes    = ["${var.trusted_ip}"]
      destination_address_prefix = "*"
    },
    https = {
      name                       = "Allow_Admin_Web_Access"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "${var.ui_port}"
      source_address_prefixes    = ["${var.trusted_ip}"]
      destination_address_prefix = "*"
    }
  }
}
