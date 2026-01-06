provider "aws" {
  region = var.aws_region
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = "vpc-xxxxxxxx"
  subnet_ids = ["subnet-xxxx", "subnet-yyyy"]

  eks_managed_node_groups = {
    prod_nodes = {
      desired_size = 2
      min_size     = 1
      max_size     = 3
      instance_types = [var.node_instance_type]
    }
  }
}