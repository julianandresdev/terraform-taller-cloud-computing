provider "aws" {
  region = var.aws_region
}

locals {
  central_key = "WH-CENTRAL"

  # Un CIDR distinto (sin solapamiento) por cada VPC
  warehouses = {
    "WH-001"     = "10.1.0.0/16"
    "WH-002"     = "10.2.0.0/16"
    "WH-003"     = "10.3.0.0/16"
    "WH-CENTRAL" = "10.0.0.0/16"
  }

  spokes = { for k, v in local.warehouses : k => v if k != local.central_key }
}

# Una VPC + subnet + IGW + route table + SG por cada warehouse
module "vpc" {
  source   = "./modules/vpc"
  for_each = local.warehouses

  name             = each.key
  vpc_cidr         = each.value
  subnet_cidr      = cidrsubnet(each.value, 8, 1)
  allowed_ssh_cidr = var.allowed_ssh_cidr

  # Central acepta trafico de todos los WH; cada WH solo de la central
  peer_cidrs = each.key == local.central_key ? values(local.spokes) : [local.warehouses[local.central_key]]
}

# Una EC2 por cada warehouse, en su propia subnet
module "ec2" {
  source   = "./modules/ec2"
  for_each = local.warehouses

  name              = each.key
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc[each.key].subnet_id
  security_group_id = module.vpc[each.key].security_group_id
  key_name          = local.key_name
}

# Peering hub-and-spoke: CENTRAL <-> cada WH-00X (el peering no es transitivo,
# por lo que WH-001, WH-002 y WH-003 NO pueden hablar entre si)
resource "aws_vpc_peering_connection" "central_to_spoke" {
  for_each = local.spokes

  vpc_id      = module.vpc[local.central_key].vpc_id
  peer_vpc_id = module.vpc[each.key].vpc_id
  auto_accept = true

  tags = {
    Name = "${local.central_key}-to-${each.key}"
  }
}

# Rutas: central -> cada spoke
resource "aws_route" "central_to_spoke" {
  for_each = local.spokes

  route_table_id            = module.vpc[local.central_key].route_table_id
  destination_cidr_block    = each.value
  vpc_peering_connection_id = aws_vpc_peering_connection.central_to_spoke[each.key].id
}

# Rutas: cada spoke -> central
resource "aws_route" "spoke_to_central" {
  for_each = local.spokes

  route_table_id            = module.vpc[each.key].route_table_id
  destination_cidr_block    = local.warehouses[local.central_key]
  vpc_peering_connection_id = aws_vpc_peering_connection.central_to_spoke[each.key].id
}
