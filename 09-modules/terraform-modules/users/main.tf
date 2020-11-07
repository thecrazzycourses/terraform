provider "aws" {
  region = "us-east-1"
  version = "~> 3.12.0"
}

variable "environment" {
  default = "default"
}

locals {
  iam_user="9582816659"
}

resource "aws_iam_user" "iam_user" {
  name = "${local.iam_user}-iam-${var.environment}"
}

