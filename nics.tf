resource "azurerm_network_interface" "nic" {
  count                         = var.pip == "Yes" ? 1 : 1
  name                          = format("%s%s%s%s%s", var.env_prefix, "-", var.vm_prefix, "-", "nic")
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  enable_ip_forwarding          = "false"
  enable_accelerated_networking = "false"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet["subnet_1"].id
    private_ip_address_allocation = "Dynamic"
    primary                       = "true"
    public_ip_address_id          = var.pip == "Yes" ? azurerm_public_ip.pip[count.index].id : null
  }
}
