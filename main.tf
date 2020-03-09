terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate71ac2932"
    container_name       = "tfstate"
    key                  = "platform.falkeredet.tfstate"
  }
}

provider "azurerm" {
  version = "=2.0.0"

  features {}
}

resource "azurerm_resource_group" "platform_rg" {
  name     = "rg-platform"
  location = "West Europe"
}

resource "azurerm_container_registry" "platform_acr" {
  name                = "acr-falkeredet-platform"
  resource_group_name = azurerm_resource_group.platform_rg.name
  location            = azurerm_resource_group.platform_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}