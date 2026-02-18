output "app_url" {
  description = "App URL: AWS = load balancer DNS; Azure = Container App FQDN"
  value       = var.cloud == "aws" ? "http://${module.aws[0].load_balancer_endpoint}" : module.azure[0].app_url
}

output "cloud" {
  description = "Currently deployed cloud (aws or azure)"
  value       = var.cloud
}

# AWS-only outputs (empty when cloud != "aws")
output "load_balancer_endpoint" {
  description = "AWS load balancer DNS (only set when cloud = aws)"
  value       = var.cloud == "aws" ? module.aws[0].load_balancer_endpoint : null
}

output "vpc_id" {
  description = "AWS VPC ID (only set when cloud = aws)"
  value       = var.cloud == "aws" ? module.aws[0].vpc_id : null
}

# Azure-only outputs (null when cloud != "azure")
output "vnet_id" {
  description = "Azure VNet ID (only set when cloud = azure)"
  value       = var.cloud == "azure" ? module.azure[0].vnet_id : null
}

output "log_analytics_workspace_id" {
  description = "Azure Log Analytics workspace ID (only set when cloud = azure)"
  value       = var.cloud == "azure" ? module.azure[0].log_analytics_workspace_id : null
}