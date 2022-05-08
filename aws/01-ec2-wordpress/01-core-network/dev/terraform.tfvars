project          = "project01"
env              = "dev"
cidr             = "10.10.0.0/16"
azs              = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
public_subnets   = ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"]
private_subnets  = ["10.10.48.0/20", "10.10.64.0/20", "10.10.80.0/20"]
database_subnets = ["10.10.96.0/20", "10.10.112.0/20", "10.10.128.0/20"]

enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false
