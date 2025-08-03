# ScribeCloud

**Seamless multilingual translation in the cloud.**

ScribeCloud is a production-ready, serverless language translation platform built on AWS. It allows you to translate text between multiple languages using **Amazon Translate**, with automation powered by **Lambda**, **API Gateway (HTTP v2)**, and **S3**, all provisioned using **Terraform**. It includes a CLI client that handles user login via Cognito Hosted UI and translates via token-authenticated API calls.

## ✨ Features

* Translate text between supported languages via AWS Translate.
* Secure login flow using Cognito Hosted UI in the CLI.
* Authenticated API calls with JWT access tokens.
* Upload and manage translation requests via CLI.
* Translate and receive results directly from CLI.
* Infrastructure-as-Code with Terraform.
* Serverless, scalable, and low-maintenance.

## 🚀 Architecture Overview

```text
User (CLI) --> Cognito Hosted UI Login
           --> Access Token
           --> API Gateway (JWT Auth)
                     |
                     v
               AWS Lambda
              /           \
     AWS S3 Requests     AWS S3 Responses
             |
     AWS Translate Service
```

## 🔧 Components

### 1. Infrastructure (`infrastructure/`)

* `modules/s3` – Secure request/response S3 buckets.
* `modules/lambda` – Lambda function that performs translation.
* `modules/iam` – IAM roles and permissions for Lambda.
* `modules/apigateway` – HTTP API Gateway v2 with Cognito JWT authorizer.
* `modules/cognito` – Cognito User Pool, Hosted UI domain, and client app.

### 2. CLI Client

* Located under `cli/`

  * `main.py` – CLI entrypoint
  * `auth.py` – Handles Cognito Hosted UI login and token storage
  * `translate.py` – Sends authenticated translation requests
* Login flow opens browser to Hosted UI, captures token, and caches it securely

## 📝 Prerequisites

* AWS CLI configured (`aws configure`)
* Terraform v1.3+
* Python 3.9+
* Valid Cognito User (via Hosted UI or Admin Invite)
* Web browser for CLI login
* No manual configuration of URL or tokens required

## ⚙️ Deployment

```bash
# Clone repository
git clone https://github.com/attaradev/scribecloud && cd scribecloud

# Initialize Terraform
terraform init

# Apply infrastructure
terraform apply -var-file="terraform.tfvars"

# Outputs will include:
# - API URL
# - Cognito Hosted UI domain
# - Congnito Client ID
```

## 🧪 CLI Usage

### Step 1: Log in (once)

```bash
python -m cli configure
```

* Opens your browser to the Cognito Hosted UI
* After login/signup, stores token locally (`~/.scribecloud/token.json`)

### Step 2: Translate text

```bash
python -m cli translate --source en --target fr --text "Hello, world"
```

### Output

```bash
✅ Translated text: 
Bonjour, le monde
```

## 🔒 Security

* **Cognito** for user authentication (via Hosted UI)
* **JWT token validation** in API Gateway using Cognito User Pool authorizer
* **S3** buckets encrypted with AWS KMS and private access only
* **IAM roles** scoped with least privilege for Lambda

## 📊 Monitoring

* CloudWatch Logs enabled for:

  * Lambda function
  * API Gateway access and errors

## ♻️ Cleanup

To destroy all resources:

```bash
terraform destroy
```

## 🙌 Contributing

Pull requests are welcome! Feel free to open issues or submit enhancements.

## 🚀 Built With

* [Amazon Translate](https://aws.amazon.com/translate/)
* [AWS Lambda](https://aws.amazon.com/lambda/)
* [Amazon S3](https://aws.amazon.com/s3/)
* [Amazon API Gateway (HTTP v2)](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)
* [Amazon Cognito](https://aws.amazon.com/cognito/)
* [Terraform](https://www.terraform.io/)
* [Python](https://www.python.org/)

By: [**Mike Attara**](https://attara.dev)
