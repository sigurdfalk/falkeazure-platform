variable "name" {
  type        = string
  description = "The name of the Key Vault."
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group for the Key Vault."
}

variable "service_principal_object_id" {
  type        = string
  description = "Service Principal object id."
}

variable "secrets" {
  type        = map(string)
  description = "A map of secrets for the Key Vault."
  default     = {}
}