output "public_subnets" {
  value = module.vpc[0].public_subnets
}

output "private_subnets" {
  value = module.vpc[0].private_subnets
}

output "vpc_id" {
  value = module.vpc[0].vpc_id
}