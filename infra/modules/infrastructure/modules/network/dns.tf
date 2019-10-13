resource "aws_route53_record" "alias_record" {
  zone_id = "${var.domain_zone_id}"
  name    = "${var.environment}.${var.domain_name_root}."
  type    = "A"

  alias = {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}