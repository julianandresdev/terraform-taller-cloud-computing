output "public_ips" {
  description = "IPs publicas de las EC2 para conectarse por SSH"
  value       = { for k, m in module.ec2 : k => m.public_ip }
}

output "private_ips" {
  description = "IPs privadas de las EC2 (para probar ping desde WH-CENTRAL)"
  value       = { for k, m in module.ec2 : k => m.private_ip }
}

output "comandos_ssh" {
  description = "Comando SSH para entrar a cada bodega"
  value = {
    for k, m in module.ec2 : k => "ssh -i ${var.usar_vockey ? "~/.ssh/labsuser.pem" : "llaves/${var.nombre_llave}.pem"} ubuntu@${m.public_ip}"
  }
}
