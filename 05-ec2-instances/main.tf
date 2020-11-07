resource "aws_default_vpc" "vpc-default" {}

resource "aws_security_group" "http-server-sg" {
  name   = "http-server-sg"
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
    name : "http-server-sg"
  }
}

resource "aws_instance" "http-server" {
  ami                    = data.aws_ami.ami-default.id
  instance_type          = "t2.micro"
  key_name               = "default-ec2"
  vpc_security_group_ids = [aws_security_group.http-server-sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.subnet-default.ids)[0]

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
