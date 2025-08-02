variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role for Lambda"
  type        = string
}

variable "requests_bucket_name" {
  description = "Name of the S3 bucket for incoming requests"
  type        = string
}

variable "responses_bucket_name" {
  description = "Name of the S3 bucket for responses"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
