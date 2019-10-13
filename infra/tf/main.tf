provider "aws" {
  region = "us-east-1"
  version = "~> 2.10"
}

/* --------- AWS & Terraform bootstrap --------

This section includes the root infrastructure to bootstrap Terraform and AWS

 ------------------------------------------- */
// root DNS

resource "aws_route53_zone" "main" {
  name = "austenconstable.com"
}

resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.main.zone_id}"
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

// Initialise s3 backend for environmental config

// Staging
resource "aws_s3_bucket" "staging-state-file-bucket" {
  bucket = "austenconstable.com-staging-state-file"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "staging-state-file-locking-table" {
  name           = "austenconstable.com-staging-state-file-locking"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "staging-app-state-file-locking-table" {
  name           = "austenconstable.com-staging-app-state-file-locking"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// Production
resource "aws_s3_bucket" "production-state-file-bucket" {
  bucket = "austenconstable.com-production-state-file"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "production-state-file-locking-table" {
  name           = "austenconstable.com-production-state-file-locking"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "production-app-state-file-locking-table" {
  name           = "austenconstable.com-production-app-state-file-locking"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}