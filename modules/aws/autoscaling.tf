# -=*=-
# ssm data: points to recommended image id
# autoscaling target:  Specify scaling service target and range
# autoscaling policy: Specify policy for when to scale service
# aws launch template: How to launch new instances (EC2) when scaling up
# aws autoscaling group: Group together EC2 instances to be scaled together
# -=*=-

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_appautoscaling_target" "ecs_service" {
  for_each           = toset(local.services)
  max_capacity       = var.max_size
  min_capacity       = var.min_size
  resource_id        = "service/${var.cluster_name}/${each.key}-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_ecs_service.python_service]
}

resource "aws_appautoscaling_policy" "scale_in" {
  for_each           = toset(local.services)
  name               = "${var.cluster_name}-scale-in"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.scale_target_value # Lower target CPU utilization (20%)
    scale_in_cooldown  = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-instance"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  user_data = base64encode(<<-EOT
              #!/bin/bash
              echo "ECS_CLUSTER=${aws_ecs_cluster.my_cluster.name}" >> /etc/ecs/ecs.config
              EOT
  )
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
}

resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
}
