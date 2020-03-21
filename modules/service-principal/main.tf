data "azurerm_client_config" "main" {}

data "azurerm_subscription" "main" {}

resource "azuread_application" "main" {
  name                       = var.name
  available_to_other_tenants = false
  identifier_uris            = [format("http://%s", var.name)]
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "random_password" "main" {
  length  = 32
  special = false
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.id
  value                = random_password.main.result
  end_date_relative    = "2400h"
}

data "azurerm_role_definition" "main" {
  count = var.role != "" ? 1 : 0
  name  = var.role
}

resource "azurerm_role_assignment" "main" {
  count              = var.role != "" ? length(local.scopes) : 0
  scope              = local.scopes[count.index]
  role_definition_id = data.azurerm_role_definition.main[0].id
  principal_id       = azuread_service_principal.main.id
}