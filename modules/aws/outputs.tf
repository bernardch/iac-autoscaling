output "load_balancer_endpoint" {
    value = "${aws_lb.python_lb.dns_name}/"
}

output "vpc_id" {
    value = module.vpc.vpc_id
}