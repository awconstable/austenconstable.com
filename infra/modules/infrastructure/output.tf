output "site_bucket_domain_name" {
  value = "${module.storage.site_bucket_domain_name}"
}

output "log_bucket_domain_name" {
  value = "${module.storage.log_bucket_domain_name}"
}

output "cdn_domain_name" {
  value = "${module.network.cdn_domain_name}"
}

output "cdn_zone_id" {
  value = "${module.network.cdn_zone_id}"
}