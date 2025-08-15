output "instance_public_ip" {
  description = "Public IP da instância criada"
  value       = aws_instance.youtube_instance.public_ip
}
