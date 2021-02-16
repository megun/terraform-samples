module "iam_role_ec2_web" {
  source = "../../../modules/iam/role/ec2"

  env       = var.env
  role_name = "web"
  attach_policies = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}
