resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.environment}.${var.domain_name_root}"
  subject_alternative_names = var.dns_aliases
  validation_method         = "DNS"

  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = var.domain_zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = aws_acm_certificate.cert.domain_validation_options[1].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[1].resource_record_type
  zone_id = var.domain_zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[1].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt2" {
  name    = aws_acm_certificate.cert.domain_validation_options[2].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[2].resource_record_type
  zone_id = var.domain_zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[2].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn,
    aws_route53_record.cert_validation_alt1.fqdn,
    aws_route53_record.cert_validation_alt2.fqdn,
  ]
}

