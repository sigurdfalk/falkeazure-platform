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
    size = "B1"
    tier = "Basic"
  }
}

resource "azurerm_app_service" "main" {
  name                = format("%s-appservice", var.name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    app_command_line = ""
    linux_fx_version = "DOCKER|falkeregistry.azurecr.io/falkeazure:latest"
    always_on        = true
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

    DOCKER_REGISTRY_SERVER_URL      = "https://falkeregistry.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = var.registry_username
    DOCKER_REGISTRY_SERVER_PASSWORD = var.registry_password

    "SPRING_PROFILES_ACTIVE" = "prod"
  }
}