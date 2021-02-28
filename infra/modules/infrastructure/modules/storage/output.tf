output "site_bucket_domain_name" {
  value = aws_s3_bucket.site_bucket.bucket_regional_domain_name
}

output "site_bucket_website_endpoint" {
  value = aws_s3_bucket.site_bucket.website_endpoint
}

output "log_bucket_domain_name" {
  value = aws_s3_bucket.log_bucket.bucket_regional_domain_name
}
