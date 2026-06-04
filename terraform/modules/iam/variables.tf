variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "kops_state_bucket_arn" {
  description = "ARN of the S3 bucket used for Kops state."
  type        = string
}

variable "kops_operator_principal_arns" {
  description = "AWS principals allowed to assume the Kops operator role."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
