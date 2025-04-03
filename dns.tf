data "aws_route53_zone" "this" {
  name         = var.subdomain
  private_zone = false
}

resource "aws_route53_record" "webapp_alias" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "" # root of the subdomain
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}