resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  values = [yamlencode({
    provider = {
      aws = {
      }
    }
    txtOwnerId = module.eks_al2.cluster_name
    policy     = "sync"
    serviceAccount = {
      create = true
      annotations = {
        "eks.amazonaws.com/role-arn" = module.external_dns_role.iam_role_arn
      }
    }
  })]
  depends_on = [helm_release.aws_lb_controller]
}
module "external_dns_role" {
  source                     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name                  = "external-dns"
  attach_external_dns_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.eks_al2.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}