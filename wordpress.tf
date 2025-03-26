resource "null_resource" "install_wordpress" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      aws eks --region eu-west-1 update-kubeconfig --name ${module.eks_al2.cluster_name};
      if (helm list -n demo | Select-String "wordpress") { 
        helm upgrade wordpress bitnami/wordpress -n demo -f values-demo.yaml 
      } else { 
        helm install wordpress bitnami/wordpress -n demo -f values-demo.yaml --create-namespace 
      };
      Start-Sleep -Seconds 5;
    EOT
  }
  depends_on = [module.eks_al2]

  triggers = {
    always_run = timestamp()
  } 
}

resource "null_resource" "patch_pvc" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      aws eks --region eu-west-1 update-kubeconfig --name ${module.eks_al2.cluster_name};
      kubectl patch pvc data-wordpress-mariadb-0 -n demo --type=merge --patch '{\"spec\":{\"storageClassName\":\"gp2\"}}'
    EOT
  }

  depends_on = [null_resource.install_wordpress]
}