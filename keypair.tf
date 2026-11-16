# Llave SSH de las 4 EC2.
# - usar_vockey = true  -> usa la llave "vockey" que AWS Academy ya trae creada.
# - usar_vockey = false -> Terraform crea una llave nueva y guarda el .pem en ./llaves/

resource "tls_private_key" "wh" {
  count     = var.usar_vockey ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wh" {
  count      = var.usar_vockey ? 0 : 1
  key_name   = var.nombre_llave
  public_key = tls_private_key.wh[0].public_key_openssh
}

resource "local_sensitive_file" "wh_pem" {
  count           = var.usar_vockey ? 0 : 1
  filename        = "${path.module}/llaves/${var.nombre_llave}.pem"
  content         = tls_private_key.wh[0].private_key_pem
  file_permission = "0400"
}

locals {
  key_name = var.usar_vockey ? "vockey" : aws_key_pair.wh[0].key_name
}
