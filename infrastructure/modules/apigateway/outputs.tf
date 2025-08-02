output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_apigatewayv2_api.api.id
}

output "api_endpoint" {
  description = "Base URL of the deployed API"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "stage_name" {
  description = "Deployed stage name"
  value       = aws_apigatewayv2_stage.stage.name
}

output "route_key" {
  description = "Route key used in the API"
  value       = aws_apigatewayv2_route.route.route_key
}

output "execution_arn" {
  description = "Execution ARN of the deployed API stage"
  value       = aws_apigatewayv2_stage.stage.execution_arn
}
