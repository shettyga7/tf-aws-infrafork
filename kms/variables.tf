variable "key_alias" {
  description = "Alias for the KMS key"
  type        = string
  default     = "alias/csye6225-kms"
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "KMS key for encrypting EC2, RDS, S3, and Secrets"
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}