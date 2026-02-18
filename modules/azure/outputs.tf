output "app_url" {
  description = "Public URL for the app (analogous to AWS ALB DNS)"
  value       = "https://${azurerm_container_app.app.latest_revision_fqdn}"
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "environment_id" {
  description = "Container Apps Environment ID (analogous to ECS cluster ARN)"
  value       = azurerm_container_app_environment.main.id
}

output "vnet_id" {
  description = "Virtual network ID (analogous to AWS VPC ID)"
  value       = azurerm_virtual_network.main.id
}

output "subnet_id" {
  description = "Subnet ID used by the Container Apps environment"
  value       = azurerm_subnet.aca_subnet.id
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID (analogous to CloudWatch log group)"
  value       = azurerm_log_analytics_workspace.main.id
}
