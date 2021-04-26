/*
resource "aws_route53_record" "alb_dns" {
  zone_id                 = var.dns_zone_id
  name                    = var.dns_custom_hostname
  type                    = "A"

  alias {
    name                  = aws_lb.alb.dns_name
    zone_id               = aws_lb.alb.zone_id
    evaluate_target_health= true
  }
}
*/