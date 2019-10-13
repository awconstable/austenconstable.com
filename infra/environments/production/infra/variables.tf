variable "accountId" {}
variable "environment" {}
variable "region" {}
variable "domain_zone_id" {}
variable "domain_name_root" {}

variable "dns_aliases" {
  type = "list"
}

variable "cdn_aliases" {
  type = "list"
}
