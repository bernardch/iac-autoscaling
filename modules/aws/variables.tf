variable "cluster_name" {
  default = "demo"
}

variable "region" {
  default = "us-west-2"
}

variable "logs_group" {
  default = "/ecs/demo"
}

variable "python_ecr_repository_url" {
  default = "<account_id>.dkr.ecr.us-west-2.amazonaws.com/<account_id>:latest"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "project_name" {
  default = "terraform-demo"
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