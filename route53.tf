resource "aws_route53_zone" "szkolenie_devops" {
  name = "szkolenie-devops.com"
}

output "route53_zone_id" {
  value = aws_route53_zone.szkolenie_devops.zone_id
}