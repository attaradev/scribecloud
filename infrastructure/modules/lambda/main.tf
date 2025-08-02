data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../lambda_function.py"
  output_path = "${path.module}/build/lambda_function.zip"
}

resource "aws_lambda_function" "translate" {
  function_name    = "${var.project_name}-translate"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  role             = var.lambda_role_arn

  environment {
    variables = {
      REQUEST_BUCKET  = var.requests_bucket_name
      RESPONSE_BUCKET = var.responses_bucket_name
    }
  }

  timeout     = 30
  memory_size = 128
  tags        = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}
