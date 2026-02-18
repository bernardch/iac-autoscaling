terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.60.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
}

# Deploy one cloud based on var.cloud ("aws" or "azure")
# Usage: terraform apply -var="cloud=aws" -var-file=dev.aws.tfvars
#        terraform apply -var="cloud=azure" -var-file=dev.azure.tfvars

module "aws" {
  count  = var.cloud == "aws" ? 1 : 0
  source = "./modules/aws"

  project_name               = var.project_name
  desired_capacity           = var.desired_capacity
  min_size                   = var.min_size
  max_size                   = var.max_size
  scale_target_value         = var.scale_target_value
  cluster_name               = var.cluster_name
  region                     = var.aws_region
  logs_group                 = var.logs_group
  python_ecr_repository_url  = var.python_ecr_repository_url
}

module "azure" {
  count  = var.cloud == "azure" ? 1 : 0
  source = "./modules/azure"

  project_name               = var.project_name
  min_size                   = var.min_size
  max_size                   = var.max_size
  scale_target_value         = var.scale_target_value
  resource_group_name        = var.azure_resource_group_name
  location                   = var.azure_location
  container_image            = var.azure_container_image
  acr_id                     = var.azure_acr_id
  acr_login_server           = var.azure_acr_login_server
}