provider "aws" {
region = "us-east-2"
}

module networking {
   source = "./modules/network/"
   vpc_cdr = var.vpc_cdr
   env = var.env
   subnet_cidr = var.subnet_cidr
   avail_zone = var.avail_zone
}

module ec2 {

  source = "./modules/instance"
  instance_type = var.instance_type
  avail_zone = var.avail_zone
  env = var.env
  vpc = module.networking.vpc_id
  snet_id = module.networking.subnet_id
}


/*
resource "aws_vpc" "demo-vpc" {
cidr_block = "20.0.0.0/24"
enable_dns_support = true
tags = {
  Name= "Terraform-vpc"
}
}
*/