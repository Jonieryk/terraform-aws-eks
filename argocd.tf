resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.26" 
  values     = [file("values-argocd.yaml")]

  depends_on = [ kubernetes_namespace.argocd, helm_release.aws_lb_controller, helm_release.cluster_autoscaler ]
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name      = "argocd"
    namespace = "argocd"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/group.name"      = "argocd"
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\":80}]"
      "external-dns.alpha.kubernetes.io/hostname" = "argocd.szkolenie-devops.com"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "argocd.szkolenie-devops.com"
      http {
        path {
          path      = "/*"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "argo-cd-argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argo_cd]
}
