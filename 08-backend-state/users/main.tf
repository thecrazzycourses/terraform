terraform {
  backend "s3" {
    bucket = "my-project-dev-backend-state"
    key = "prj/backend-state"
    region = "us-east-1"
    dynamodb_table = "dev_application_lock"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
  version = "~> 3.12.0"
}

resource "aws_iam_user" "iam_user" {
  name = "${terraform.workspace}-9582816659-iam"
}

