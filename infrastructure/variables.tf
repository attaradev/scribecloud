variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project base name"
  type        = string
  default     = "scribecloud"
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = "alias/aws/s3"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "scribecloud"
  }
}
