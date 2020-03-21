data "azuread_user" "main" {
  object_id = "16c4d35f-2c84-4d92-8994-9bc1b7c3b58a"
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_client_config" "main" {}

resource "azurerm_key_vault" "main" {
  name                        = var.name
  location                    = data.azurerm_resource_group.main.location
  resource_group_name         = data.azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.main.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.main.tenant_id
    object_id = data.azuread_user.main.object_id

    key_permissions = [
      "get",
      "create",
      "list",
    ]

    secret_permissions = [
      "get",
      "set",
      "list",
    ]

    storage_permissions = [
      "get",
      "list",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.main.tenant_id
    object_id = var.service_principal_object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }
}

resource "azurerm_key_vault_secret" "main" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id
}