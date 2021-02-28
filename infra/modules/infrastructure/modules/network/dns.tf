resource "aws_route53_record" "alias_record" {
  zone_id = var.domain_zone_id
  name    = "${var.environment}.${var.domain_name_root}."
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mailchimp_auth_txt" {
  zone_id = var.domain_zone_id
  name    = "txt.${var.domain_name_root}."
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:servers.mcsv.net ?all"]
}


resource "aws_route53_record" "mailchimp_auth_cname" {
  zone_id = var.domain_zone_id
  name    = "k1._domainkey"
  type    = "CNAME"
  ttl     = "300"
  records = ["dkim.mcsv.net"]
}