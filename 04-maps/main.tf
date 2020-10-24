provider "aws" {
  region  = "us-east-1"
  version = "~> 3.12.0"
}

variable "iam_user_prefix" {
  type = string # any, number, string, list, map, set, object, tuple
  # default = "9582816659"
}

variable "names" {
  type = map
}

resource "aws_iam_user" "iam_user" {
  for_each = var.names
  name     = "${var.iam_user_prefix}-iam-${each.key}"

  tags = {
    city : each.value.city
  }
}

