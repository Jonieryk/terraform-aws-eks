resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name    = module.eks_al2.cluster_name
  addon_name      = "aws-ebs-csi-driver"
  addon_version   = "v1.40.1-eksbuild.1"  # Specify the version you want

  depends_on = [ module.eks_al2 ]
}

# IAM Policy for EBS CSI Driver
resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name        = "AmazonEBSCSIDriverPolicy"
  description = "Policy for EBS CSI Driver"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume",
          "ec2:ModifyVolume",
          "ec2:DescribeSnapshots",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:CreateRole"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "EBSCSIDriverRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${local.region}.amazonaws.com/id/${module.eks_al2.cluster_name}"
        }
        Condition = {
          StringEquals = {
            "oidc.eks.${local.region}.amazonaws.com/id/${module.eks_al2.cluster_name}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
}
