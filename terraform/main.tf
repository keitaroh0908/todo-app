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

module "api_gateway" {
  source = "./services/api_gateway"

  cognito_user_pool_name                 = module.cognito.cognito_user_pool_name
  get_task_lambda_invoke_arn             = module.lambda.get_task_invoke_arn
  get_tasks_by_user_id_lambda_invoke_arn = module.lambda.get_tasks_by_user_id_invoke_arn
  create_task_lambda_invoke_arn          = module.lambda.create_task_invoke_arn
  update_task_lambda_invoke_arn          = module.lambda.update_task_invoke_arn
}

module "cognito" {
  source = "./services/cognito"
}

module "dynamodb" {
  source = "./services/dynamodb"
}

module "ecr" {
  source = "./services/ecr"
}

module "lambda" {
  source = "./services/lambda"

  account_id          = var.account_id
  dynamodb_table_name = module.dynamodb.table_name
}

module "s3" {
  source = "./services/s3"
}

module "vpc" {
  source = "./services/vpc"
}
