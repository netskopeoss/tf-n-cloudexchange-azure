resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.own_cert == "Yes" ? 1 : 1
  name                            = format("%s%s%s%s%s", var.env_prefix, "-", var.vm_prefix, "-", "VM")
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  admin_username                  = var.admin_username
  disable_password_authentication = true

  identity {
    type = "SystemAssigned"
  }
  custom_data = var.own_cert == "No" ? base64encode(templatefile("${path.root}/scripts/bootstrap-selfsigned.tpl", { tenant = var.tenant_name, port = var.ui_port, jwt = var.jwt_secret, password = var.maintenance_password, beta = var.beta_opt_in })) : base64encode(templatefile("${path.root}/scripts/bootstrap-owncert.tpl", { tenant = var.tenant_name, port = var.ui_port, jwt = var.jwt_secret, password = var.maintenance_password, beta = var.beta_opt_in, kv = data.azurerm_key_vault.kvuri[count.index].vault_uri }))

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.admin_ssh_key)
  }

  size = var.vm_size

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stg.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = var.img_sku
    version   = var.img_version
  }

  os_disk {
    name                 = format("%s%s%s%s%s", var.env_prefix, "-", var.vm_prefix, "-", "disk")
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = "64"
  }
}
