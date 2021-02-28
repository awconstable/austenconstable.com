resource "aws_route53_record" "root_alias_record" {
  zone_id = var.domain_zone_id
  name    = "${var.domain_name_root}."
  type    = "A"

  alias {
    name                   = module.production-infrastructure.cdn_domain_name
    zone_id                = module.production-infrastructure.cdn_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_alias_record" {
  zone_id = var.domain_zone_id
  name    = "www.${var.domain_name_root}."
  type    = "A"

  alias {
    name                   = module.production-infrastructure.cdn_domain_name
    zone_id                = module.production-infrastructure.cdn_zone_id
    evaluate_target_health = false
  }
}

