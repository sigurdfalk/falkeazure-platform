data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_app_service_plan" "main" {
  name                = format("%s-plan", var.name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  kind                = "linux"
  reserved            = true

  sku {
    size = "F1"
    tier = "Free"
  }
}