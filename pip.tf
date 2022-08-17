#PIP for Initial Configuration or remote access.
resource "azurerm_public_ip" "pip" {
  count               = var.pip == "Yes" ? 1 : 0
  name                = format("%s%s%s%s%s", var.env_prefix, "-", var.vm_prefix, "-", "pip")
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}
