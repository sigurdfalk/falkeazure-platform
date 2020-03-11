data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_container_registry" "platform_acr" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Basic"
  admin_enabled       = true
}

