variable "project_name" {
  description = "Project name used in resource names"
  default     = "terraform_demo"
}

variable "min_size" {
  description = "Minimum replicas"
  default     = 1
}

variable "max_size" {
  description = "Maximum replicas"
  default     = 3
}

variable "scale_target_value" {
  description = "Target CPU utilization percentage for app autoscaling"
  default     = 30.0
}

variable "location" {
  description = "Azure region"
  default     = "canadacentral"
}

variable "resource_group_name" {
  description = "Resource group name"
  default     = "terraform_demo"
}

variable "container_image" {
  description = "Container image for the app (e.g. your ACR image)"
  default     = "demopython.azurecr.io/demo-python:latest"
}

variable "acr_id" {
  description = "Full Azure resource ID of the Container Registry (for pull permission)"
  type        = string
}

variable "acr_login_server" {
  description = "ACR login server (e.g. demopython.azurecr.io)"
  type        = string
}
