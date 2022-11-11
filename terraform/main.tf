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

module "alb" {
  source = "./services/alb"

  public_subnet_ids = module.vpc.production_public_subnet_ids
  vpc_id            = module.vpc.production_vpc_id
}

module "api_gateway" {
  source = "./services/api_gateway"

  cognito_user_pool_name                 = module.cognito.cognito_user_pool_name
  get_tasks_by_user_id_lambda_invoke_arn = module.lambda.get_tasks_by_user_id_invoke_arn
  create_task_lambda_invoke_arn          = module.lambda.create_task_invoke_arn
  delete_task_lambda_invoke_arn          = module.lambda.delete_task_invoke_arn
}

module "cognito" {
  source = "./services/cognito"
}

module "config" {
  source = "./services/config"

  account_id = var.account_id
}

module "cloudfront" {
  source = "./services/cloudfront"

  bucket_id                   = module.s3.web_bucket_id
  bucket_regional_domain_name = module.s3.web_bucket_regional_domain_name
}

module "dynamodb" {
  source = "./services/dynamodb"
}

module "ecr" {
  source = "./services/ecr"
}

module "ecs" {
  source = "./services/ecs"

  private_subnet_ids    = module.vpc.production_private_subnet_ids
  target_group_arn      = module.alb.target_group_arn
  ecr_repository_url    = module.ecr.repository_url
  vpc_id                = module.vpc.production_vpc_id
  alb_security_group_id = module.alb.security_group_id
}

module "lambda" {
  source = "./services/lambda"

  account_id                = var.account_id
  dynamodb_table_name       = module.dynamodb.table_name
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
}

module "route53" {
  source = "./services/route53"
}

module "s3" {
  source = "./services/s3"

  cloudfront_origin_access_identity_iam_arn = module.cloudfront.cloudfront_origin_access_identity_iam_arn
}

module "vpc" {
  source = "./services/vpc"
}
