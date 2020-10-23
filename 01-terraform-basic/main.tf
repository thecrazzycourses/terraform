provider "aws" {
  region = "us-east-1"
  version = "~> 3.11.0"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "9582816659-bucket"
  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "iam_user" {
  name = "9582816659-iam"
}

