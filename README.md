# austenconstable.com
austenconstable.com

## Getting Started

### Bootstrap Terraform
One time bootstrap of the root Terraform deployment by creating:
1. An S3 bucket
   1. Name: austenconstable.com-terraform-state 
1. A DynamoDB table
   1. Name: austenconstable.com-terraform-state-lock
   1. Primary Partition Key: LockID
   1. Read/Write Mode: On-Demand
   
_Note: These need to be manually created in the AWS console_
 
### Deploy root infrastructure
This deploys the root domain name and backend storage for each environment.
It should very rarely need to change and should have additional due diligence in place.

1. Set env vars for AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY
1. Run:
```
cd tf
terraform init
terraform plan
terraform apply
```
### Deploy modular infrastructure
Deploys an identical per-environment config. [See here](https://github.com/fedekau/terraform-with-circleci-example)
1. Set env vars for AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY
1. Run:
```
cd environments/[environment name] 
terraform init
terraform plan
terraform apply
```