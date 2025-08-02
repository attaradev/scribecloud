variable "project_name" {
  description = "The base name of the project used for naming resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "requests_bucket_arn" {
  description = "ARN of the S3 bucket where translation requests are stored"
  type        = string
}

variable "responses_bucket_arn" {
  description = "ARN of the S3 bucket where translation responses are stored"
  type        = string
}
