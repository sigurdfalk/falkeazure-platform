variable "name" {
  type        = string
  description = "The name of the App Service."
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group for the App Service."
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type = string
}