
resource "aws_ecs_cluster" "my_cluster" {
  name = var.cluster_name
  tags = {
    Name = "terraform-demo"
  }
}

resource "aws_ecs_task_definition" "python" {
  family                   = "python"
  network_mode             = "bridge"
  cpu                      = "1024"
  memory                   = "512"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "python"
      image     = var.python_ecr_repository_url
      essential = true
      cpu       = 1024
      memory    = 512
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        },
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.logs_group
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "python"
        }
      }
    }
  ])
  tags = {
    Name = "terraform-demo"
  }
}

resource "aws_ecs_service" "python_service" {
  name                 = "python-service"
  cluster              = aws_ecs_cluster.my_cluster.id
  task_definition      = aws_ecs_task_definition.python.arn
  launch_type          = "EC2"
  desired_count        = 1
  force_new_deployment = true
  load_balancer {
    target_group_arn = aws_lb_target_group.python_tg.arn
    container_name   = "python"
    container_port   = 5000
  }
  tags = {
    Name = "terraform-demo"
  }
}