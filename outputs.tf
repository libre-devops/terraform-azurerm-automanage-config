output "automanage_name" {
  description = "The name of automange config"
  value       = {for k, v in azurerm_automanage_configuration.automanage_configs : k => v.name}
}

output "automanage_id" {
  description = "The id of automange config"
  value       = {for k, v in azurerm_automanage_configuration.automanage_configs : k => v.id}
}

output "automanage_rg_name" {
  description = "The rg_name of automange config"
  value       = {for k, v in azurerm_automanage_configuration.automanage_configs : k => v.resource_group_name}
}

output "automanage_tags" {
  description = "The tags of automange config"
  value       = {for k, v in azurerm_automanage_configuration.automanage_configs : k => v.tags}
}

