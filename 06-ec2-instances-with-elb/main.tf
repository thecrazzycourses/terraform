resource "aws_default_vpc" "vpc-default" {}

resource "aws_security_group" "elb-sg" {
  name   = "elb-sg"
  vpc_id = aws_default_vpc.vpc-default.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name : "elb-sg"
  }
}

resource "aws_elb" "elb" {
  name = "elb"
  subnets = data.aws_subnet_ids.subnet-default.ids
  security_groups = [aws_security_group.elb-sg.id]
  instances = values(aws_instance.ec2).*.id

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

resource "aws_security_group" "ec2-sg" {
  name   = "ec2-sg"
  vpc_id = aws_default_vpc.vpc-default.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name : "ec2-sg"
  }
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ami-default.id
  instance_type          = "t2.micro"
  key_name               = "default-ec2"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  for_each = data.aws_subnet_ids.subnet-default.ids
  subnet_id              = each.value

  tags = {
    name: "https-servers-${each.value}"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.ec2-key-pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Welcome to EC2 Instance - Virtual Server is at ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}
