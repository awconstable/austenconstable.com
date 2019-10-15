module "network" {
  source                       = "modules/network"

  environment                  = "${var.environment}"
  domain_zone_id               = "${var.domain_zone_id}"
  domain_name_root             = "${var.domain_name_root}"
  site_bucket_domain_name      = "${module.storage.site_bucket_domain_name}"
  site_bucket_website_endpoint = "${module.storage.site_bucket_website_endpoint}"
  log_bucket_domain_name       = "${module.storage.log_bucket_domain_name}"
  ssl_cert_arn                 = "${var.ssl_cert_arn}"
  cdn_aliases                  = "${var.cdn_aliases}"
}

module "storage" {
  source                  = "modules/storage"

  environment             = "${var.environment}"
  region                  = "${var.region}"
  domain_name_root        = "${var.domain_name_root}"
}
