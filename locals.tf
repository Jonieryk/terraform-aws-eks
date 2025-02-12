locals {
  name   = "demo-2"
  region = "eu-west-1"

  tags = {
    Name       = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}