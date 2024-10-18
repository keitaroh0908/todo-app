module "production_vpc" {
  source = "../../elements/vpc/vpc"

  cidr_block  = "10.0.0.0/16"
  environment = "production"
}

module "development_vpc" {
  source = "../../elements/vpc/vpc"

  cidr_block  = "10.10.0.0/16"
  environment = "development"
}

module "production_public_subnet" {
  source = "../../elements/vpc/subnet"

  vpc_id             = module.production_vpc.id
  name               = "production_public"
  cidr_blocks        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

module "production_private_subnet" {
  source = "../../elements/vpc/subnet"

  vpc_id             = module.production_vpc.id
  name               = "production_private"
  cidr_blocks        = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

module "development_public_subnet" {
  source = "../../elements/vpc/subnet"

  vpc_id             = module.development_vpc.id
  name               = "development_public"
  cidr_blocks        = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

module "development_private_subnet" {
  source = "../../elements/vpc/subnet"

  vpc_id             = module.development_vpc.id
  name               = "development_private"
  cidr_blocks        = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

module "production_internet_gateway" {
  source = "../../elements/vpc/internet_gateway"

  vpc_id = module.production_vpc.id
}

module "development_internet_gateway" {
  source = "../../elements/vpc/internet_gateway"

  vpc_id = module.development_vpc.id
}

module "production_nat_gateway" {
  source = "../../elements/vpc/nat_gateway"

  subnet_id = module.production_public_subnet.ids[0]
}

module "development_nat_gateway" {
  source = "../../elements/vpc/nat_gateway"

  subnet_id = module.development_public_subnet.ids[0]
}

module "production_public_route_table" {
  source = "../../elements/vpc/public_route_table"

  vpc_id              = module.production_vpc.id
  internet_gateway_id = module.production_internet_gateway.id
}

module "production_private_route_table" {
  source = "../../elements/vpc/private_route_table"

  vpc_id         = module.production_vpc.id
  nat_gateway_id = module.production_nat_gateway.id
}

resource "aws_route_table_association" "production_public" {
  count          = length(module.production_public_subnet.ids)
  route_table_id = module.production_public_route_table.id
  subnet_id      = element(module.production_public_subnet.ids, count.index)
}

resource "aws_route_table_association" "production_private" {
  count          = length(module.production_private_subnet.ids)
  route_table_id = module.production_private_route_table.id
  subnet_id      = element(module.production_private_subnet.ids, count.index)
}

module "development_public_route_table" {
  source = "../../elements/vpc/public_route_table"

  vpc_id              = module.development_vpc.id
  internet_gateway_id = module.development_internet_gateway.id
}

module "development_private_route_table" {
  source = "../../elements/vpc/private_route_table"

  vpc_id         = module.development_vpc.id
  nat_gateway_id = module.development_nat_gateway.id
}

resource "aws_route_table_association" "development_public" {
  count          = length(module.development_public_subnet.ids)
  route_table_id = module.development_public_route_table.id
  subnet_id      = element(module.development_public_subnet.ids, count.index)
}

resource "aws_route_table_association" "development_private" {
  count          = length(module.development_private_subnet.ids)
  route_table_id = module.development_private_route_table.id
  subnet_id      = element(module.development_private_subnet.ids, count.index)
}

resource "aws_vpc_endpoint" "this" {
  vpc_id          = module.production_vpc.id
  service_name    = "com.amazonaws.ap-northeast-1.dynamodb"
  route_table_ids = [module.production_private_route_table.id]
}
