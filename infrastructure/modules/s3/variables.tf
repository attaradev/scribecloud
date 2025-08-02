variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "kms_key_id" {
  description = "KMS Key ID used for encryption"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Force destroy the bucket on delete"
  type        = bool
  default     = false
}
