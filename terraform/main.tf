module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.eks.ids

  # ✅ FIX: prevent CloudWatch conflict
  create_cloudwatch_log_group = false

  # ❌ DO NOT define cluster_encryption_config at all

  eks_managed_node_groups = {
    prod_nodes = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = [var.node_instance_type]
    }
  }
}
