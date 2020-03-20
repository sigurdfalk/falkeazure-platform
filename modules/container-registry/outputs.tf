output "repository_username" {
  value = azurerm_container_registry.platform_acr.admin_username
}

output "repository_password" {
  value = azurerm_container_registry.platform_acr.admin_password
}

output "id" {
  value = azurerm_container_registry.platform_acr.id
}