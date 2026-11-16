output "public_ip" {
  description = "IP publica de la EC2"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "IP privada de la EC2"
  value       = aws_instance.this.private_ip
}
