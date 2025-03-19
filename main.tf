data "aws_eks_cluster" "eks_al2" {
  depends_on = [module.eks_al2]
  name       = module.eks_al2.cluster_name
}

data "aws_eks_cluster_auth" "eks_al2" {
  depends_on = [module.eks_al2]
  name       = module.eks_al2.cluster_name
}

module "eks_al2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name}-al2"
  cluster_version = "1.32"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    ebs-csi-driver         = {}
  }


  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_groups = {
    node-group = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.large"]

      min_size = 1
      max_size = 2
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 1
    }
  }

  tags = local.tags
}