output "user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.this.id
}

output "app_client_id" {
  description = "Cognito App Client ID"
  value       = aws_cognito_user_pool_client.this.id
}

output "hosted_ui_domain" {
  description = "Cognito Hosted UI Domain Prefix"
  value       = aws_cognito_user_pool_domain.this.domain
}
