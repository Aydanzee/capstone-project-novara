variable "aws_region" {
  description = "AWS region for the capstone foundation."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and resource names."
  type        = string
  default     = "capstone-project-novara"
}

variable "environment" {
  description = "Environment name for this deployment."
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "Registered domain to delegate to Route53, for example example.com. Leave empty until ready."
  type        = string
  default     = ""
}

variable "extra_dns_records" {
  description = "Additional Route53 records to create in the hosted zone, such as existing ACM validation CNAMEs."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "vpc_cidr" {
  description = "CIDR block for the TaskApp VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the three public subnets used by NAT gateways and load balancers."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "Exactly three public subnet CIDR blocks are required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the three private subnets used by Kubernetes control-plane and worker nodes."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "Exactly three private subnet CIDR blocks are required."
  }
}

variable "terraform_state_bucket_name" {
  description = "Optional globally unique S3 bucket name for Terraform remote state. If null, a name is generated from account ID and region."
  type        = string
  default     = null
}

variable "kops_state_bucket_name" {
  description = "Optional globally unique S3 bucket name for Kops state. If null, a name is generated from account ID and region."
  type        = string
  default     = null
}

variable "terraform_lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  type        = string
  default     = "capstone-project-novara-terraform-locks"
}

variable "kops_cluster_name" {
  description = "Planned Kops cluster DNS name. This should usually be a subdomain of the delegated Route53 zone."
  type        = string
  default     = "taskapp.example.com"
}

variable "kops_operator_principal_arns" {
  description = "Optional AWS principal ARNs allowed to assume the Kops operator role. Leave empty until the IAM user/role is known."
  type        = list(string)
  default     = []
}
