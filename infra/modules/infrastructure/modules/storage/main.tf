resource "aws_s3_bucket" "site_bucket" {
  bucket        = "${var.environment}.${var.domain_name_root}.${var.region}"
  force_destroy = true
  tags = {
    environment = var.environment
  }
}

resource "aws_s3_bucket_website_configuration" "site_bucket" {
  bucket = aws_s3_bucket.site_bucket.bucket

  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_acl" "site_bucket" {
  bucket = aws_s3_bucket.site_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = "${var.environment}.logs.${var.domain_name_root}.${var.region}"
  force_destroy = true

  tags = {
    environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}
