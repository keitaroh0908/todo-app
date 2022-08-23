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
}

module "cognito" {
  source = "./services/cognito"
}

module "dynamodb" {
  source = "./services/dynamodb"
}

module "lambda" {
  source = "./services/lambda"

  account_id          = var.account_id
  dynamodb_table_name = module.dynamodb.table_name
}
