module "vpc1_network" {
  source       = "./modules/network"
  cidr_block   = var.cidr_block
  project_name = var.project_name
  tags         = local.tags
  vpc1_nlb     = module.vpc1_compute.vpc1_nlb
}

module "vpc1_compute" {
  source                 = "./modules/compute"
  project_name           = var.project_name
  tags                   = local.tags
  vpc1_public_subnet_1a  = module.vpc1_network.public_subnet_1a
  vpc1_public_subnet_1b  = module.vpc1_network.public_subnet_1b
  vpc1_private_subnet_1a = module.vpc1_network.private_subnet_1a
  vpc1_private_subnet_1b = module.vpc1_network.private_subnet_1b
  vpc_id                 = module.vpc1_network.vpc_id
}