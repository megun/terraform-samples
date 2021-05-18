module "ecr_frontend" {
  source = "../../modules/ecr"

  name   = var.ecr_name_frontend
  policy = file("./lifecycle_policy.json")
  tags   = local.common_tags
}

module "ecr_backend" {
  source = "../../modules/ecr"

  name   = var.ecr_name_backend
  policy = file("./lifecycle_policy.json")
  tags   = local.common_tags
}

resource "null_resource" "image_push" {
  triggers = {
    now_date = timestamp()
  }

  # nginxのイメージビルドしてプッシュ
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${data.aws_region.current.name} --profile megun002 | docker login --username AWS --password-stdin ${module.ecr_frontend.ecr_repository_url}"
  }
  provisioner "local-exec" {
    command = "docker build -t ${var.ecr_name_frontend} ${var.path_sample_app_frontend}"
  }
  provisioner "local-exec" {
    command = "docker tag ${var.ecr_name_frontend}:latest ${module.ecr_frontend.ecr_repository_url}:latest"
  }
  provisioner "local-exec" {
    command = "docker push ${module.ecr_frontend.ecr_repository_url}:latest"
  }

  # goアプリのイメージビルドしてプッシュ
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${data.aws_region.current.name} --profile megun002 | docker login --username AWS --password-stdin ${module.ecr_backend.ecr_repository_url}"
  }
  provisioner "local-exec" {
    command = "docker build -t ${var.ecr_name_backend} ${var.path_sample_app_backend}"
  }
  provisioner "local-exec" {
    command = "docker tag ${var.ecr_name_backend}:latest ${module.ecr_backend.ecr_repository_url}:latest"
  }
  provisioner "local-exec" {
    command = "docker push ${module.ecr_backend.ecr_repository_url}:latest"
  }

  depends_on = [
    module.ecr_frontend,
    module.ecr_backend,
  ]
}
