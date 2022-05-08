resource "aws_iam_role" "codedeploy" {
  name = "${var.project}-${var.env}-codedeploy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}

resource "aws_codedeploy_app" "wordpress" {
  compute_platform = "Server"
  name             = "${var.project}-${var.env}-wordpress"
}

resource "aws_codedeploy_deployment_group" "wordpress" {
  app_name              = aws_codedeploy_app.wordpress.name
  deployment_group_name = var.env
  service_role_arn      = aws_iam_role.codedeploy.arn

  autoscaling_groups = data.aws_autoscaling_groups.wordpress.names

  load_balancer_info {
    target_group_info {
      name = data.aws_lb_target_group.wordpress.name
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
}


### pipeline
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.project}-${var.env}-github"
  provider_type = "GitHub"
}


resource "aws_s3_bucket" "codepipeline_artifact" {
  bucket = "megun-${var.project}-${var.env}-codepipeline-artifact"

  force_destroy = true
}

resource "aws_s3_bucket_acl" "codepipeline_artifact" {
  bucket = aws_s3_bucket.codepipeline_artifact.id
  acl    = "private"
}

resource "aws_iam_role" "codepipeline" {
  name = "${var.project}-${var.env}-codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "${var.project}-${var.env}-codepipeline"
  role = aws_iam_role.codepipeline.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifact.arn}",
        "${aws_s3_bucket.codepipeline_artifact.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.github.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:GetApplicationRevision",
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetDeployment"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "wordpress" {
  name     = "wordpress"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "megun/wp-app-1"
        BranchName       = var.target_brunch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.wordpress.name
        DeploymentGroupName = aws_codedeploy_deployment_group.wordpress.deployment_group_name
      }
    }
  }
}
