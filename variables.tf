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