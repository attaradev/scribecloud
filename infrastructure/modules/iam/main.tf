resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Translate API access
      {
        Sid    = "AllowTranslateText",
        Effect = "Allow",
        Action = [
          "translate:TranslateText"
        ],
        Resource = "*"
      },

      # Full access (read/write) to request bucket
      {
        Sid    = "AllowS3AccessRequestBucket",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "${var.requests_bucket_arn}/*"
      },

      # Full access (read/write) to response bucket
      {
        Sid    = "AllowS3AccessResponseBucket",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "${var.responses_bucket_arn}/*"
      },

      # CloudWatch logging
      {
        Sid    = "AllowLambdaLogging",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })

  lifecycle {
    prevent_destroy = false
  }
}
