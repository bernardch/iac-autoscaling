terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = ">= 3.0.0"
    # }
  }
}
provider "aws" {
  region = var.aws_region
}

module "aws" {
  source = "./modules/aws"
  # count  = var.cloud == "aws" ? 1 : 0

  # providers = {
  #   aws = aws
  # }

  project_name         = var.project_name
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  scale_target_value   = var.scale_target_value
  python_ecr_repository_url = var.python_ecr_repository_url
}

# module "azure" {
#   source = "./modules/azure"
#   count  = var.cloud == "azure" ? 1 : 0

#   app_name             = var.app_name
#   desired_capacity     = var.desired_capacity
#   min_size             = var.min_size
#   max_size             = var.max_size
#   scale_up_threshold   = var.scale_up_threshold
#   scale_down_threshold = var.scale_down_threshold
# }

# provider "azurerm" {
#     region = 
# }

# locals {
#   services = ["python"]
# }