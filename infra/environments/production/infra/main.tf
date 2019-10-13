provider "aws" {
  region  = "us-east-1"
  version = "~> 2.10"
}

resource "aws_route53_record" "mx" {
  zone_id = "${var.domain_zone_id}"
  name    = "austenconstable.com."
  type    = "MX"
  ttl     = 3600

  records = [
    "5 gmr-smtp-in.l.google.com",
    "10 alt1.gmr-smtp-in.l.google.com",
    "20 alt2.gmr-smtp-in.l.google.com",
    "30 alt3.gmr-smtp-in.l.google.com",
    "40 alt4.gmr-smtp-in.l.google.com",
  ]
}

module "production-infrastructure" {
  source = "../../../modules/infrastructure"

  environment      = "${var.environment}"
  region           = "${var.region}"
  domain_zone_id   = "${var.domain_zone_id}"
  domain_name_root = "${var.domain_name_root}"
  ssl_cert_arn     = "${aws_acm_certificate_validation.cert.certificate_arn}"
  cdn_aliases      = "${var.cdn_aliases}"
}
