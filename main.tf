data "aws_region" "current" {}

module "networking" {
  source               = "./modules/networking"
  avail_zone           = data.aws_region.current.name
  prefix               = local.prefix
  common_tags          = local.common_tags
  vpc_cidr_block       = "10.10.0.0/16"
  cidr_block_private_a = "10.10.16.0/20"
  cidr_block_public_a  = "10.10.96.0/20"
}

module "asg" {
  source    = "./modules/asg"
  subnet_id = module.networking.private_a_subnet_id
  vpc_id    = module.networking.vpc_id
  vpc_zone_identifier = [ module.networking.private_a_subnet_id ]
  health_check_type = "EC2"
  ssh_key_name = "id_rsa.juliosaraiva.pub"
}