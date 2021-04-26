output "alb_arn" {
  description             = "ARN of ALB fronting ECS cluster"
  value                   = aws_lb.alb.arn 
}

output "alb_dns" {
  description             = "DNS name of ALB fronting ECS cluster"
  value                   = aws_lb.alb.dns_name 
}

/*
output "alb_alias_fqdn" {
  description             = "FQDN of alias DNS record associated with the ALB"
  value                   = aws_route53_record.alb_dns.fqdn
}
*/