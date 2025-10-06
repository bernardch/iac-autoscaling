data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_appautoscaling_target" "ecs_service" {
  for_each           = toset(local.services)
  max_capacity       = 3
  min_capacity       = 1
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
    target_value       = 50.0 # Lower target CPU utilization (20%)
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
  instance_type = "t3.micro"
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
  desired_capacity    = 3
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
}
