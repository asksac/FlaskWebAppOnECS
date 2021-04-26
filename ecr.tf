locals {
  ecs_container_name          = lower(replace(var.app_name, "/[^\\w]+/", ""))
  ecs_container_tag           = "latest"
  ecr_url_tag                 = "${aws_ecr_repository.registry.repository_url}:${local.ecs_container_tag}"
}

resource "aws_ecr_repository" "registry" {
  name                        = local.ecs_container_name
  image_tag_mutability        = "MUTABLE"

  image_scanning_configuration {
    scan_on_push              = false
  }

  lifecycle {
    #prevent_destroy           = true
  }

  tags                        = local.common_tags
}

# Equivalent of aws ecr get-login
data "aws_ecr_authorization_token" "ecr_token" {}

resource "null_resource" "renew_ecr_token" {
  triggers = {
    token_expired             = data.aws_ecr_authorization_token.ecr_token.expires_at
  }

  provisioner "local-exec" {
    command                   = "echo ${data.aws_ecr_authorization_token.ecr_token.password} | docker login --username ${data.aws_ecr_authorization_token.ecr_token.user_name} --password-stdin ${data.aws_ecr_authorization_token.ecr_token.proxy_endpoint}"
  }
}

resource "null_resource" "docker_build" {
  triggers = {
    dockerfile                = filesha1("${path.module}/app/Dockerfile")
    app_py                    = filesha1("${path.module}/app/app.py")
  }

  provisioner "local-exec" {
    command                   = "docker build -t ${local.ecs_container_name} ./app"
  }
}

resource "null_resource" "docker_push" {
  triggers = {
    dockerfile                = filesha1("${path.module}/app/Dockerfile")
    app_py                    = filesha1("${path.module}/app/app.py")
  }

  provisioner "local-exec" {
    command                   = "docker tag ${local.ecs_container_name} ${local.ecr_url_tag} && docker push ${local.ecr_url_tag}"
  }

  depends_on                  = [ null_resource.renew_ecr_token, null_resource.docker_build ]
}

