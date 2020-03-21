output "kv_sdk_auth" {
  value = module.kv_service_principal.sdk_auth
  description = "Output JSON compatible with the Azure SDK auth file."
}