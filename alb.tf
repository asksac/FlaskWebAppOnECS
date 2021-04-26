resource "aws_lb" "alb" {
  name_prefix             = "${var.app_shortcode}-"
  internal                = false
  load_balancer_type      = "application"

  security_groups         = [ aws_security_group.alb_sg.id ]
  subnets                 = var.subnet_ids
  enable_cross_zone_load_balancing  = false

  lifecycle {
    create_before_destroy = true
  }

  tags                    = local.common_tags
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn       = aws_lb.alb.arn
  port                    = var.alb_listen_port # inbound port of ALB
  protocol                = "HTTP"

  default_action {
    type                  = "forward"
    target_group_arn      = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name_prefix             = "${var.app_shortcode}-"
  port                    = var.webapp_listen_port # outbound port of ALB / inbound of targets
  protocol                = "HTTP"  
  target_type             = "ip" # ECS requires target type as ip
  vpc_id                  = var.vpc_id

  /*
  # TODO: Stickiness based on application-generated cookie is currently not supported 
  # by Terraform, therefore this must be set manually via Management Console
  stickiness {
    enabled               = true
    type                  = "app_cookie"
  }
  */

  lifecycle {
    create_before_destroy = true
  }

  deregistration_delay    = 120 # default is 300s

  depends_on              = [ aws_lb.alb ]
  tags                    = local.common_tags
}
