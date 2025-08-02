locals {
  env_suffix            = var.environment
  tagged_project        = "${var.project_name}-${local.env_suffix}"
  requests_bucket_name  = "scribecloud-requests-${local.env_suffix}"
  responses_bucket_name = "scribecloud-responses-${local.env_suffix}"

  requests_bucket_arn  = "arn:aws:s3:::${local.requests_bucket_name}"
  responses_bucket_arn = "arn:aws:s3:::${local.responses_bucket_name}"

  common_tags = merge(var.tags, {
    Project     = "scribecloud"
    Environment = local.env_suffix
  })
}

# === S3 Buckets ===

module "requests_bucket" {
  source        = "./modules/s3"
  bucket_name   = local.requests_bucket_name
  kms_key_id    = var.kms_key_id
  force_destroy = false

  tags = merge(local.common_tags, {
    Name = local.requests_bucket_name
  })
}

module "responses_bucket" {
  source        = "./modules/s3"
  bucket_name   = local.responses_bucket_name
  kms_key_id    = var.kms_key_id
  force_destroy = false

  tags = merge(local.common_tags, {
    Name = local.responses_bucket_name
  })
}

# === IAM Role for Lambda Access ===

module "iam" {
  source               = "./modules/iam"
  project_name         = var.project_name
  requests_bucket_arn  = local.requests_bucket_arn
  responses_bucket_arn = local.responses_bucket_arn
  tags                 = local.common_tags
}

# === Lambda Function ===

module "lambda" {
  source                = "./modules/lambda"
  project_name          = local.tagged_project
  lambda_role_arn       = module.iam.lambda_role_arn
  requests_bucket_name  = local.requests_bucket_name
  responses_bucket_name = local.responses_bucket_name
  tags                  = local.common_tags
}

# === Cognito Authentication ===

module "cognito" {
  source       = "./modules/cognito"
  project_name = var.project_name
  tags         = var.tags
}

# === API Gateway ===

module "apigateway" {
  source       = "./modules/apigateway"
  project_name = local.tagged_project
  environment  = local.env_suffix
  aws_region   = var.region

  lambda_function_name  = module.lambda.lambda_function_name
  lambda_function_arn   = module.lambda.lambda_function_arn
  cognito_user_pool_id  = module.cognito.user_pool_id
  cognito_app_client_id = module.cognito.app_client_id
  tags                  = local.common_tags
}

# === Lambda Permission for API Gateway ===

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowAPIGatewayInvoke-${var.environment}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.apigateway.execution_arn}/POST/translate"

  depends_on = [
    module.lambda,
    module.apigateway
  ]
}
