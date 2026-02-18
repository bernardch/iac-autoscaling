# -----------------------------------------------------------------------------
# Azure module: analogous to AWS (Consumption-only, no Dedicated/VMSS)
# - VNet + subnet (analogous to VPC + subnets)
# - NSG (analogous to security groups)
# - Log Analytics workspace (analogous to CloudWatch log group)
# - Identity + ACR role (analogous to IAM task execution role)
# - Container App Environment (analogous to ECS cluster)
# - Container App + ingress (analogous to ECS service + ALB)
# - CPU scale rule (analogous to Application Auto Scaling)
# -----------------------------------------------------------------------------

# Compute not required for Azure Container Apps
# Would need to provision Azure Virtual Machines, but this is would incur additional cost beyond Free Tier subscription

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

