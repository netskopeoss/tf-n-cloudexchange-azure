resource "azurerm_virtual_network" "vnet" {
  name                = format("%s%s%s%s%s%s", var.env_prefix, "CNR", "-", "CE", "-", "vnet")
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = each.value["name"]
  address_prefixes     = each.value["address_prefixes"]
  service_endpoints    = var.own_cert == "Yes" ? ["Microsoft.KeyVault"] : null
}
