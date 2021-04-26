terraform {
  required_version        = ">= 0.12"
  required_providers {
    aws                   = ">= 3.11.0"
  }
}

provider "aws" {
  profile                 = var.aws_profile
  region                  = var.aws_region
}

data "aws_vpc" "selected" {
  id                      = var.vpc_id
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Application           = var.app_name
    Environment           = var.aws_env
  }

}