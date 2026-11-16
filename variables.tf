variable "aws_region" {
  type        = string
  description = "Region de AWS para el despliegue"
  default     = "us-east-1"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR desde el cual se permite SSH a las EC2"
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia"
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI para las instancias (Ubuntu 26.04, us-east-1)"
  default     = "ami-0d97d7f07b25dd693"
}

variable "usar_vockey" {
  type        = bool
  description = "true: usa la llave vockey de AWS Academy. false: crea una llave nueva"
  default     = true
}

variable "nombre_llave" {
  type        = string
  description = "Nombre de la llave nueva (solo se usa si usar_vockey = false)"
  default     = "wh-taller-terraform"
}
