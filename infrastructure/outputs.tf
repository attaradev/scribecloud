output "scribecloud_api_url" {
  description = "Public endpoint for the ScribeCloud translate API"
  value       = module.apigateway.api_endpoint
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.lambda_function_name
}

output "requests_bucket_name" {
  description = "Requests bucket name"
  value       = local.requests_bucket_name
}

output "responses_bucket_name" {
  description = "Responses bucket name"
  value       = local.responses_bucket_name
}

output "cognito_hosted_ui_url" {
  description = "Cognito Hosted UI URL"
  value       = "https://${module.cognito.hosted_ui_domain}.auth.${var.region}.amazoncognito.com"
}

output "user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "app_client_id" {
  description = "Cognito App Client ID"
  value       = module.cognito.app_client_id
}
