# output "app_url" {
#   value = var.cloud == "aws" ? module.aws[0].app_url : module.azure[0].app_url
# }

output "load_balancer_endpoint" {
    value = module.aws.load_balancer_endpoint
}

output "vpc_id" {
    value = module.aws.vpc_id
}