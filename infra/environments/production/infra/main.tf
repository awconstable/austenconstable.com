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
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM",
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
