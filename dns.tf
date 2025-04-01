variable "dev_zone_id" {
  description = "Route53 Hosted Zone ID for dev.ganeshshetty.me"
  type        = string
}

resource "aws_route53_record" "webapp_alias" {
  zone_id = var.dev_zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}