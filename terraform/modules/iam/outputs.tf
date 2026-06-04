output "kops_operator_policy_arn" {
  description = "IAM policy ARN for Kops operations."
  value       = aws_iam_policy.kops_operator.arn
}

output "kops_operator_role_arn" {
  description = "IAM role ARN for Kops operations, if created."
  value       = try(aws_iam_role.kops_operator[0].arn, null)
}
