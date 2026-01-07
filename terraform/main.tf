provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

# ✅ Get only supported AZs for EKS control plane
data "aws_subnets" "eks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d",
      "us-east-1f"
    ]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  # 🔴 Required for Jenkins reruns
  create_kms_key              = false
  cluster_encryption_config   = {}
  create_cloudwatch_log_group = false

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.eks.ids

  eks_managed_node_groups = {
    prod_nodes = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = [var.node_instance_type]
    }
  }
}
