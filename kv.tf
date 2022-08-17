data "azurerm_client_config" "current" {
}
data "azurerm_key_vault" "kvuri" {
  count               = var.own_cert == "Yes" ? 1 : 0
  resource_group_name = azurerm_key_vault.kv[count.index].resource_group_name
  name                = azurerm_key_vault.kv[count.index].name
}

# Create KV and set network acls.
resource "azurerm_key_vault" "kv" {
  count                    = var.own_cert == "Yes" ? 1 : 0
  name                     = format("%s%s%s%s%s%s", var.env_prefix, "CSV", "-", "CE", "-", "kv")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    # trusted_ip
    ip_rules                   = ["${var.trusted_ip}"]
    virtual_network_subnet_ids = [azurerm_subnet.subnet["subnet_1"].id]
  }
}

# set access policy for CE VM
resource "azurerm_key_vault_access_policy" "ce" {
  count        = var.own_cert == "Yes" ? 1 : 0
  key_vault_id = azurerm_key_vault.kv[count.index].id
  tenant_id    = azurerm_linux_virtual_machine.vm[count.index].identity[0].tenant_id
  object_id    = azurerm_linux_virtual_machine.vm[count.index].identity[0].principal_id
  certificate_permissions = [
    "Get",
    "List",
  ]
  secret_permissions = [
    "Get",
    "List",
  ]
  key_permissions = [
    "Get",
    "List",
  ]

}

#set access policy for admin
resource "azurerm_key_vault_access_policy" "admin" {
  count        = var.own_cert == "Yes" ? 1 : 0
  key_vault_id = azurerm_key_vault.kv[count.index].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "ListIssuers",
    "SetIssuers",
    "DeleteIssuers",
    "Purge",
  ]
  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge",
  ]
  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge",
  ]
}

#store certificate and associated private key
resource "azurerm_key_vault_secret" "cert" {
  count = var.own_cert == "Yes" ? 1 : 0
  name  = "ce-cert"
  value        = replace(file("${path.module}/certificates/${var.ssl_cert}"), "/\n/", "\n")
  key_vault_id = azurerm_key_vault.kv[count.index].id
  depends_on = [
    azurerm_key_vault_access_policy.admin
  ]
}
resource "azurerm_key_vault_secret" "key" {
  count = var.own_cert == "Yes" ? 1 : 0
  name  = "ce-key"
  value        = replace(file("${path.module}/certificates/${var.ssl_key}"), "/\n/", "\n")
  key_vault_id = azurerm_key_vault.kv[count.index].id
  depends_on = [
    azurerm_key_vault_access_policy.admin
  ]
}
