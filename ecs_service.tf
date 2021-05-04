resource "aws_ecs_cluster" "main" {
  name                            = "${var.app_shortcode}-ecs-cluster"
  setting {
    name                          = "containerInsights"
    value                         = "enabled"
  }

  tags                            = local.common_tags
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name                            = "${var.app_name}/app-logs"
  tags                            = local.common_tags
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                          = "${var.app_shortcode}-webapp"
  network_mode                    = "awsvpc"
  requires_compatibilities        = ["FARGATE"]
  cpu                             = "1024"
  memory                          = "2048"
  execution_role_arn              = aws_iam_role.ecs_exec_role.arn
  task_role_arn                   = aws_iam_role.tasks_iam_role.arn

  container_definitions           = jsonencode([
    {
      name =  "${var.app_shortcode}-webapp"
      image = local.ecr_url_tag
      networkMode = "awsvpc" 
      essential = true 
      linuxParameters = {
        initProcessEnabled = true
      }
      portMappings = [
        { 
          containerPort = var.webapp_listen_port 
          hostPort = var.webapp_listen_port 
        }
      ], 
      logConfiguration = {
        logDriver = "awslogs" 
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs-task"
        }
      }
    }
  ])

  tags                            = local.common_tags
}

resource "aws_ecs_service" "main" {
  name                            = "${var.app_shortcode}-ecs-service"
  cluster                         = aws_ecs_cluster.main.id
  task_definition                 = aws_ecs_task_definition.ecs_task.arn
  desired_count                   = var.min_cluster_size
  launch_type                     = "FARGATE"

  lifecycle {
    ignore_changes                = [ desired_count ]
  }

  deployment_maximum_percent          = 200
  deployment_minimum_healthy_percent  = 50
  health_check_grace_period_seconds   = 15

  enable_execute_command          = true

  network_configuration {
    security_groups               = [ aws_security_group.ecs_sg.id ]
    subnets                       = var.subnet_ids
    assign_public_ip              = true
  }

  load_balancer {
    target_group_arn              = aws_lb_target_group.alb_tg.id
    container_name                = "${var.app_shortcode}-webapp"
    container_port                = var.webapp_listen_port
  }

  depends_on                      = [ 
    aws_lb_listener.alb_listener, 
    aws_security_group.ecs_sg, 
    null_resource.docker_push 
  ]
}