provider "aws" {
  region = "us-east-1"
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.eks.ids

  # 🚨 FORCE PUBLIC API
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # 🔥 DISABLE ENCRYPTION (avoid KMS delays)
  cluster_encryption_config = {}

  create_cloudwatch_log_group = false

  eks_managed_node_groups = {
    prod_nodes = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t2.medium"]
    }
  }
}
