provider "aws" {
  region = "us-east-1"
  version = "~> 3.11.0"
}

variable "iam_user_prefix" {
  type = string # any, number, string, list, map, set, object, tuple
  # default = "9582816659"
}

variable "names" {
  type = list(string)
}

resource "aws_iam_user" "iam_user" {
  #count = length(var.names)
  #name = "${var.iam_user_prefix}-iam-${var.names[count.index]}"

  # Above is list which will modify everything if we add in start or middle as state file store like index_key=0, index_key=1 ( these are index )
  # Solution is to change this to Set

  # With Set key will be name like index_key="1", index_key="2" ( these are actual value )
  for_each = toset(var.names)
  name = "${var.iam_user_prefix}-iam-${each.value}"
}

