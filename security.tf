resource "aws_security_group" "ecs_sg" {
  name_prefix             = "${var.app_shortcode}-ecs-sg-"
  vpc_id                  = var.vpc_id

  # TODO: allow egress traffic (should be restricted)
  # needs access to ECS endpoint, ECR to pull containers and CloudWatch Logs
  egress {
    from_port             = 443
    to_port               = 443
    protocol              = "tcp"
    cidr_blocks           = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port             = var.webapp_listen_port
    to_port               = var.webapp_listen_port
    protocol              = "tcp"
    cidr_blocks           = [ data.aws_vpc.selected.cidr_block ]
  }

  tags                    = local.common_tags
}

resource "aws_security_group" "alb_sg" {
  name_prefix             = "${var.app_shortcode}-alb-sg-"
  vpc_id                  = var.vpc_id

  egress {
    from_port             = var.webapp_listen_port
    to_port               = var.webapp_listen_port
    protocol              = "tcp"
    cidr_blocks           = [ data.aws_vpc.selected.cidr_block ]
  }

  ingress {
    from_port             = var.alb_listen_port
    to_port               = var.alb_listen_port
    protocol              = "tcp"
    cidr_blocks           = var.source_cidr_blocks
  }

  tags                    = local.common_tags
}

resource "aws_iam_role" "ecs_exec_role" {
  name                    = "${var.app_shortcode}-ecs-exec-role"
  assume_role_policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags                    = local.common_tags
}

resource "aws_iam_policy" "ecs_exec_role_permissions" {
  name                    = "${var.app_shortcode}-ecs-role-permissions"
  description             = "Provides ECS tasks access to AWS services"

  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents", 
        "ssm:GetParameters", 
        "ecs:StartTelemetrySession"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role                    = aws_iam_role.ecs_exec_role.name
  policy_arn              = aws_iam_policy.ecs_exec_role_permissions.arn
}
