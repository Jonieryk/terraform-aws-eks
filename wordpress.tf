resource "helm_release" "wordpress" {
  name       = "wordpres"
  namespace  = "demo"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  version    = "24.1.18"

# values = [<<EOF
#     service:
#       type: LoadBalancer
#     ingress:
#       enabled: true
#       ingressClassName: "alb"
#       hostname: "wordpress.example.com"
#       annotations:
#         kubernetes.io/ingress.class: "alb"
#         cert-manager.io/cluster-issuer: "letsencrypt-prod"
#         alb.ingress.kubernetes.io/scheme: internet-facing
#         alb.ingress.kubernetes.io/target-type: ip
#         alb.ingress.kubernetes.io/group.name: wordpress
#         alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'  # Use HTTP instead of HTTPS
#       tls: 
#         - hosts: 
#             - wordpress.szkolenie-devops.com
#         secretName: wordpress-tls
#     EOF
#   ]
}
