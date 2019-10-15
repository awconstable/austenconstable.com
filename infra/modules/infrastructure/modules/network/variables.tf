variable "environment" {}
variable "domain_zone_id" {}
variable "domain_name_root" {}
variable "log_bucket_domain_name" {}
variable "site_bucket_domain_name" {}
variable "site_bucket_website_endpoint" {}
variable "ssl_cert_arn" {}
variable "cdn_aliases" {
  type    = "list"
}