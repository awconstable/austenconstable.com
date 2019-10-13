terraform {
  backend "s3" {
    bucket         = "austenconstable.com-production-state-file"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "austenconstable.com-production-state-file-locking"
  }
}
