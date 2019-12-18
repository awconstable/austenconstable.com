# Terraform Infrastructure Deployment

## Getting Started

### Bootstrap Terraform

One time bootstrap of the root Terraform deployment by creating the following using the AWS console.

1. An S3 bucket
   1. Name: austenconstable.com-terraform-state
1. A DynamoDB table
   1. Name: austenconstable.com-terraform-state-lock
   1. Primary Partition Key: LockID
   1. Read/Write Mode: On-Demand

### Deploy root infrastructure

This deploys the root domain name and backend storage for each environment.
It should very rarely need to change and should have additional due diligence in place.

1. Set AWS credentials in ~/.aws/credentials

```yaml
[default]
  2 aws_access_key_id = XXXXXX
  3 aws_secret_access_key = XXXXXX
```

1. Run:

```bash
cd tf
terraform init
terraform plan
terraform apply
```

### Deploy modular infrastructure

Deploys an identical per-environment config. [See here](https://github.com/fedekau/terraform-with-circleci-example)

1. Set env vars for AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY
1. Run:

```bash
cd environments/[environment name]
terraform init
terraform plan
terraform apply
```
