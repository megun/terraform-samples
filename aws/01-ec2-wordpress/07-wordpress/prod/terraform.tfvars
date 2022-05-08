project           = "project01"
env               = "prod"
min_size          = 2
max_size          = 2
health_check_type = "EC2"
image_id          = "ami-02c3627b04781eada"
instance_type     = "t3.micro"
root_volume_size  = 20

custom_role_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
]
