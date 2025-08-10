output "aws_instance_public_dns" {
  value       = "http://${aws_instance.ngnix1.public_dns}"
  description = "Public DNS hostname for the ec2 instance"
}



