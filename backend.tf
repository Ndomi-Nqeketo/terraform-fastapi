resource "aws_dynamodb_table" "dynamodb-lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "terraform-state-lock"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-lock-fastapi"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.region
}