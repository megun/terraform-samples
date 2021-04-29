variable "project" {
  type    = string
  default = "s3-apigateway-lambda"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "assume_role" {
  type = string
}

variable "dynamodb_tablename" {
  type    = string
  default = "hello-world"
}

variable "s3_hosting_bucket_name" {
  type    = string
  default = "megun-s3-hosting"
}

variable "api-gateway_name" {
  type    = string
  default = "hello-world"
}

variable "lambda_function_name" {
  type = string
  default = "s3-apigateway-lambda-prod-lambda"
}
