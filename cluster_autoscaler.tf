resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks_al2.cluster_name
  }
  set {
    name  = "awsRegion"
    value = local.region
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  set {
    name  = "fullnameOverride"
    value = "aws-cluster-autoscaler"
  }
  set {
    name  = "rbac.serviceAccout.create"
    value = "true"
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_eks_role.arn
  }
}
module "iam_eks_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                        = "cluster-autoscaler"
  create_role                      = true
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [module.eks_al2.cluster_name]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks_al2.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}