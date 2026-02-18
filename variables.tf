variable "cloud" {
  description = "Which cloud to deploy: 'aws' or 'azure'. Use -var='cloud=aws' or -var-file=dev.aws.tfvars (with cloud=\"aws\") for AWS; -var='cloud=azure' or -var-file=dev.azure.tfvars for Azure."
  type        = string
  default     = "aws"

  validation {
    condition     = contains(["aws", "azure"], var.cloud)
    error_message = "cloud must be either \"aws\" or \"azure\"."
  }
}

variable "aws_region" {
  default = "us-west-2"
}

variable "project_name" {
  default = "terraform_demo"
}

variable "desired_capacity" {
  default = 3
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 3
}

variable "scale_target_value" {
  default = 30.0
}

variable "cluster_name" {
  default = "demo"
}

variable "logs_group" {
  default = "logs_group"
}

variable "python_ecr_repository_url" {
  default = "<account_id>.dkr.ecr.us-west-2.amazonaws.com/<account_id>:latest"
}

# Azure (Container Apps on VMSS) variables
variable "azure_resource_group_name" {
  description = "Resource group for Azure resources"
  default     = "terraform_demo"
}

variable "azure_location" {
  description = "Azure region"
  default     = "canadacentral"
}

variable "azure_container_image" {
  description = "ACR image for the demo app"
  default     = "demopython.azurecr.io/demo-python:latest"
}

variable "azure_acr_id" {
  description = "Full resource ID of the Azure Container Registry (for pull permission). Required when cloud = azure."
  type        = string
  default     = ""
}

variable "azure_acr_login_server" {
  description = "ACR login server (e.g. demopython.azurecr.io). Required when cloud = azure."
  type        = string
  default     = ""
}

variable "azure_dedicated_profile_name" {
  description = "Name of the Dedicated workload profile (VMSS)"
  default     = "dedicated"
}

variable "azure_dedicated_profile_type" {
  description = "Dedicated profile VM type (e.g. D4, D8)"
  default     = "D4"
}