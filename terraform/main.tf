terraform {
  backend "s3" {
    bucket = "terraform.graduation-thesis.bs219031.sun.ac.jp"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "./services/vpc"
}

module "s3" {
  source = "./services/s3"

  origin_access_identity_id = module.cloudfront.origin_access_identity_id
}

module "cloudfront" {
  source = "./services/cloudfront"

  images_bucket_regional_domain_name = module.s3.images_bucket_regional_domain_name
  logs_bucket_regional_domain_name   = module.s3.logs_bucket_regional_domain_name
}

module "dynamodb" {
  source = "./services/dynamodb"
}

module "lambda" {
  source = "./services/lambda"

  account_id          = var.account_id
  dynamodb_table_name = module.dynamodb.table_name
}
