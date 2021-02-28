# Terraform Infrastructure Deployment

## Getting Started

### Install Terraform/tfenv 
Install terraform using tfenv, a terraform version manager which makes life much easier. https://github.com/tfutils/tfenv

```bash
brew install tfenv
tfenv install 0.12.30
```

### Bootstrap Terraform

One time bootstrap of the root Terraform deployment by creating the following using the AWS console.

1. An S3 bucket
   1. Name: austenconstable.com-terraform-state
1. A DynamoDB table
   1. Name: austenconstable.com-terraform-state-lock
   1. Primary Partition Key: LockID
   1. Read/Write Mode: On-Demand

### Setup AWS credentials

Set AWS credentials in ~/.aws/credentials
```yaml
[default]
  aws_access_key_id = XXXXXX
  aws_secret_access_key = XXXXXX
```

### Deploy bootstrap infrastructure

This deploys the root domain name and backend storage for each environment.
It should very rarely need to change and should have additional due diligence in place.

```bash
cd tf
terraform init
terraform plan
terraform apply
```

### Deploy modular infrastructure

Deploys an identical per-environment config. [See here](https://github.com/fedekau/terraform-with-circleci-example)

```bash
cd environments/[environment name]
terraform init
terraform plan
terraform apply
```
