bucket         = "my-scribecloud-tfstate"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "my-scribecloud-tflock"
