provider "aws" {
  region = "us-east-1"
  version = "~> 3.11.0"
}

variable "iam_user_prefix" {
  type = string # any, number, string, list, map, set, object, tuple
  # default = "9582816659"
}

resource "aws_iam_user" "iam_user" {
  count = 2
  name = "${var.iam_user_prefix}-iam-${count.index}"
}

