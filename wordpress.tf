resource "helm_release" "wordpress" {
  name       = "wordpress"
  namespace  = "demo"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  version    = "23.1.29"
}

# resource "kubernetes_manifest" "data-wordpress-mariadb-0" {
#   manifest = {
#     apiVersion = "v1"
#     kind       = "PersistentVolumeClaim"
#     metadata = {
#       name      = "data-wordpress-mariadb-0"
#       namespace = "demo"
#     }
#     spec = {
#       storageClassName = "gp2"
#     }
#   }
# }

resource "kubernetes_ingress_v1" "wordpress_ingress" {
  metadata {
    name      = "wordpress"
    namespace = "demo"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" : "internet-facing"
      "alb.ingress.kubernetes.io/target-type" : "ip"
      "alb.ingress.kubernetes.io/group.name" : "wordpress"
      "alb.ingress.kubernetes.io/listen-ports" : "[{\"HTTP\":80}]"
      "external-dns.alpha.kubernetes.io/hostname" : "wordpress.szkolenie-devops.com"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      host = "wordpress.szkolenie-devops.com"
      http {
        path {
          backend {
            service_name = "wordpress"
            service_port = 80
          }
        }
      }
    }
  }
}