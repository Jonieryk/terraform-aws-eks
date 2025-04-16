resource "kubernetes_namespace" "demo" {
  depends_on = [module.eks_al2]
  metadata {
    name = "demo"
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [module.eks_al2]
  metadata {
    name = "argocd"
  }
}