variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources"
}
