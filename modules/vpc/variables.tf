variable "name" {
  type        = string
  description = "Nombre del warehouse (WH-001, ...)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR de la VPC"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR de la subnet"
}

variable "peer_cidrs" {
  type        = list(string)
  description = "CIDRs desde los que se permite trafico (VPCs con peering)"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR permitido para SSH"
}
