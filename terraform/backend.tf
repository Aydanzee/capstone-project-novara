terraform {
  backend "s3" {
    bucket         = "capstone-project-novara-dev-tfstate-027355625786-us-east-1"
    key            = "capstone-project-novara/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "capstone-project-novara-terraform-locks"
    encrypt        = true
  }
}
