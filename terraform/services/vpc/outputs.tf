output "production_vpc_id" {
  value = module.production_vpc.id
}

output "production_public_subnet_ids" {
  value = module.production_public_subnet.ids
}

output "production_private_subnet_ids" {
  value = module.production_private_subnet.ids
}
