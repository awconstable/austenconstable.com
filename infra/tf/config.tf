terraform {
  backend "s3" {
    bucket         = "austenconstable.com-terraform-state"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "austenconstable.com-terraform-state-lock"
  }
}

