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
    name  = "rbac.serviceAccou.create"
    value = "true"
  }

}