data "aws_subnet_ids" "subnet-default" {
  vpc_id = aws_default_vpc.vpc-default.id
}

data "aws_ami" "ami-default" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami_ids" "ami-default-ids" {
  owners = ["amazon"]
}

