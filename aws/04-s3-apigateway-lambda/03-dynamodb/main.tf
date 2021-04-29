module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.0.0"

  name     = var.dynamodb_tablename
  hash_key = "ID"

  attributes = [
    {
      name = "ID"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}
