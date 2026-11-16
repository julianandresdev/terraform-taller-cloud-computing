variable "name" {
  type        = string
  description = "Nombre de la EC2 (WH-001)"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia"
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID para la instancia"
}

variable "subnet_id" {
  type        = string
  description = "Subnet donde se lanza la instancia"
}

variable "security_group_id" {
  type        = string
  description = "Security group de la instancia"
}

variable "key_name" {
  type        = string
  description = "Nombre de la llave SSH (key pair) de la instancia"
}
