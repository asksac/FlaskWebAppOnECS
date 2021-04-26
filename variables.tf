variable "aws_profile" {
  type                    = string
  default                 = "default"
  description             = "Specify aws profile name to use for access credentials"
}

variable "aws_region" {
  type                    = string
  default                 = "us-east-1"
  description             = "Specify AWS region to use for deployment"
}

variable "aws_env" {
  type                    = string
  default                 = "dev"
  description             = "Specify a value for the Environment tag"
}

variable "app_name" {
  type                    = string
  description             = "Specify the application or project name"
}

variable "app_shortcode" {
  type                    = string
  description             = "Specify a short-code or pneumonic for this application or project"
}

variable "vpc_id" {
  type                    = string
  description             = "Specify a VPC ID where this module will be deployed"
}

variable "subnet_ids" {
  type                    = list 
  description             = "Specify a list of Subnet IDs where this module will be deployed"
}

variable "source_cidr_blocks" {
  type                    = list
  default                 = [ "0.0.0.0/0" ] 
  description             = "Specify list of source CIDR ranges for ALB's security group ingress rules"
}

variable "webapp_listen_port" {
  type                    = number
  default                 = 5000
  description             = "Specify port at which webapp in container listens at"
}

variable "alb_listen_port" {
  type                    = number
  default                 = 8080
  description             = "Specify listener port for ALB (for inbound requests)"
}

variable "min_cluster_size" {
  type                    = number
  default                 = 2
  description             = "Specify minimum number of tasks maintained in ECS service cluster"
}

variable "max_cluster_size" {
  type                    = number
  default                 = 4
  description             = "Specify maximum number of tasks allowed in ECS service cluster"
}

variable "autoscaling_low_cpu_mark" {
  type                    = number
  default                 = 20
  description             = "Specify the low CPU utilization watermark for cluster scale-in"
}

variable "autoscaling_high_cpu_mark" {
  type                    = number
  default                 = 70
  description             = "Specify the high CPU utilization watermark for cluster scale-out"
}

variable "dns_zone_id" {
  type                    = string
  description             = "Specify a Route53 private DNS Zone ID for creating alias records"
}

variable "dns_custom_hostname" {
  type                    = string
  description             = "Specify a custom DNS record name to map to ALB"
}
