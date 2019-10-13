resource "aws_s3_bucket" "site_bucket" {
  bucket        = "${var.environment}.${var.domain_name_root}.${var.region}"
  acl           = "private"
  force_destroy = true

  tags {
    environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = "${var.environment}.logs.${var.domain_name_root}.${var.region}"
  acl           = "private"
  force_destroy = true

  tags {
    environment = "${var.environment}"
  }
}