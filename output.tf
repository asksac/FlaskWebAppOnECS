output "alb_arn" {
  description             = "ARN of ALB fronting ECS cluster"
  value                   = aws_lb.alb.arn 
}

output "alb_url" {
  description             = "DNS name of ALB fronting ECS cluster"
  value                   = "http://${aws_lb.alb.dns_name}:${var.alb_listen_port}"
}

/*
output "alb_alias_fqdn" {
  description             = "FQDN of alias DNS record associated with the ALB"
  value                   = aws_route53_record.alb_dns.fqdn
}
*/