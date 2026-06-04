variable "domain_name" {
  description = "Registered domain name for Route53 hosted zone."
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a Route53 hosted zone."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
