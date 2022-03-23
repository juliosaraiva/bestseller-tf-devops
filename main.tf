terraform {
  cloud {
    organization = "Bestseller-dev"

    workspaces {
      name = terraform.workspace
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
  }
}

module "networking" {
  source               = "./modules/networking"
  avail_zone           = data.aws_region.current.name
  prefix               = local.prefix
  common_tags          = local.common_tags
  vpc_cidr_block       = "10.10.0.0/16"
  cidr_block_private_a = "10.10.16.0/20"
  cidr_block_public_a  = "10.10.96.0/20"
}