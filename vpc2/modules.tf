module "vpc2_network" {
  source       = "./modules/network"
  cidr_block   = var.cidr_block
  project_name = var.project_name
  tags         = local.tags
}

module "vpc2_compute" {
  source                 = "./modules/compute"
  project_name           = var.project_name
  tags                   = local.tags
  vpc2_public_subnet_1a  = module.vpc2_network.public_subnet_1a
  vpc2_public_subnet_1b  = module.vpc2_network.public_subnet_1b
  vpc_id                 = module.vpc2_network.vpc_id
  vpc2_private_subnet_1a = module.vpc2_network.private_subnet_1a
}