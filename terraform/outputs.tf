output "aws_region" {
  description = "AWS region used by this foundation."
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID for the Kubernetes cluster."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for NAT gateways and load balancers."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for Kubernetes control-plane and worker nodes."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs, one per AZ."
  value       = module.vpc.nat_gateway_ids
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID, if a domain was provided."
  value       = module.dns.zone_id
}

output "route53_name_servers" {
  description = "Name servers to configure at your domain registrar."
  value       = module.dns.name_servers
}

output "terraform_state_bucket_name" {
  description = "S3 bucket for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_lock_table_name" {
  description = "DynamoDB lock table for Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "kops_state_bucket_name" {
  description = "S3 bucket for Kops state."
  value       = aws_s3_bucket.kops_state.bucket
}

output "kops_operator_policy_arn" {
  description = "IAM policy ARN for Kops cluster creation and operations."
  value       = module.iam.kops_operator_policy_arn
}

output "kops_operator_role_arn" {
  description = "IAM role ARN for Kops operations, if trusted principals were supplied."
  value       = module.iam.kops_operator_role_arn
}
