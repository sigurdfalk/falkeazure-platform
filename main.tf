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

module "container_registry" {
  source              = "./modules/container-registry"
  name                = "falkeregistry"
  resource_group_name = azurerm_resource_group.platform_rg.name
}

module "app_service" {
  source = "./modules/app-service"
  name = "falkeappservice"
  resource_group_name = azurerm_resource_group.platform_rg.name
}