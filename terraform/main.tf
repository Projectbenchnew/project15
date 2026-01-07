provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  # 🔴 CRITICAL FIXES (DO NOT REMOVE)
  create_kms_key              = false
  cluster_encryption_config   = {}
  create_cloudwatch_log_group = false

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  eks_managed_node_groups = {
    prod_nodes = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = [var.node_instance_type]
    }
  }
}
