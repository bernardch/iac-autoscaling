resource "aws_cloudwatch_log_group" "logs_group" {
  name = var.logs_group
  tags = {
    Name = var.project_name
  }
}
