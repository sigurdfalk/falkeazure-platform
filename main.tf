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

module "acr" {
  source              = "./modules/container-registry"
  name                = "falkeregistry"
  resource_group_name = azurerm_resource_group.platform_rg.name
}

module "acr_service_principal" {
  source = "./modules/service-principal"
  name   = "falkeregistryprincipal"
  role   = "AcrPush"
  scopes = [module.acr.id]
}

module "kv_service_principal" {
  source = "./modules/service-principal"
  name   = "falkekeyvaultprincipal"
}

module "kv" {
  source                      = "./modules/key-vault"
  name                        = "falkekeyvault"
  resource_group_name         = azurerm_resource_group.platform_rg.name
  service_principal_object_id = module.kv_service_principal.object_id

  secrets = {
    "acrSpClientId"     = module.acr_service_principal.client_id
    "acrSpClientSecret" = module.acr_service_principal.client_secret
  }
}

module "app_service" {
  source              = "./modules/app-service"
  name                = "falkeappservice"
  resource_group_name = azurerm_resource_group.platform_rg.name
  registry_username   = module.acr_service_principal.client_id
  registry_password   = module.acr_service_principal.client_secret
}