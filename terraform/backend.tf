# Remote state is intentionally documented but not enabled by default.
# First run the bootstrap resources in this configuration with local state:
#
#   terraform init
#   terraform plan
#   terraform apply
#
# After the Terraform state S3 bucket and DynamoDB lock table exist, uncomment
# and fill this backend block, then run `terraform init -migrate-state`.
#
# terraform {
#   backend "s3" {
#     bucket         = "REPLACE_WITH_TERRAFORM_STATE_BUCKET"
#     key            = "capstone-project-novara/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "REPLACE_WITH_DYNAMODB_LOCK_TABLE"
#     encrypt        = true
#   }
# }
