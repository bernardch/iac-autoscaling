variable "cloud" {
  default = "aws"
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
  default= "logs_group"
}

variable "python_ecr_repository_url" {
  default = "<account_id>.dkr.ecr.us-west-2.amazonaws.com/<account_id>:latest"
}