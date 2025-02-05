resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  values = [yamlencode({
    clusterName = module.eks_al2.cluster_name
    serviceAccount = {
        create = true
        name = "aws-load-balancer-controller"
        annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_eks_role.iam_role_arn
        }
    }
  })]
  

}