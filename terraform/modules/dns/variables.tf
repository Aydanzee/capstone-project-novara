variable "domain_name" {
  description = "Registered domain name for Route53 hosted zone."
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a Route53 hosted zone."
  type        = bool
  default     = false
}

variable "extra_records" {
  description = "Additional Route53 records to preserve or create in the hosted zone."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
