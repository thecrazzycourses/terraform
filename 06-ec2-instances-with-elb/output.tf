output "elb-public-dns" {
  value = aws_elb.elb
}

output "ec2-public-dns" {
  value = values(aws_instance.ec2).*.id
}
