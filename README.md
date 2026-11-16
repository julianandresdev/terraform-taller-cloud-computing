# 🏭 Taller Terraform: Bodegas en AWS

Con Terraform levanto 4 bodegas en AWS: **WH-001**, **WH-002**, **WH-003** y **WH-CENTRAL**.

## 🎯 Qué hace

- Cada bodega es una máquina (EC2) con su propia red (VPC), subred y firewall (security group).
- **WH-CENTRAL** puede comunicarse con las 3 bodegas.
- **WH-001, WH-002 y WH-003 no pueden comunicarse entre ellas.** Solo hablan con la central.

```
        WH-001
           │
WH-002 ── WH-CENTRAL ── WH-003

(las bodegas solo se conectan con la central)
```

| Bodega | Red |
|---|---|
| WH-CENTRAL | 10.0.0.0/16 |
| WH-001 | 10.1.0.0/16 |
| WH-002 | 10.2.0.0/16 |
| WH-003 | 10.3.0.0/16 |

## 📁 Archivos

| Archivo | Para qué sirve |
|---|---|
| `main.tf` | Crea las bodegas y las conecta con la central |
| `keypair.tf` | Maneja la llave para entrar por SSH |
| `variables.tf` | Valores que se pueden cambiar |
| `outputs.tf` | Muestra las IPs y los comandos SSH al terminar |
| `versions.tf` | Versiones de Terraform y AWS |
| `enviroments/terraform.tfvars` | Mis valores (región y tipo de llave) |
| `modules/vpc/` | Red, subred y firewall de cada bodega |
| `modules/ec2/` | La máquina de cada bodega |

## 🚀 Cómo ejecutarlo

1. Iniciar el laboratorio en AWS Academy y copiar las credenciales (AWS Details) en `~/.aws/credentials`.
2. Descargar la llave `labsuser.pem` y guardarla en `~/.ssh/`:

```bash
chmod 400 ~/.ssh/labsuser.pem
```

3. Ejecutar:

```bash
terraform init
terraform plan -var-file=enviroments/terraform.tfvars
terraform apply -var-file=enviroments/terraform.tfvars
```

> Si no se puede usar `vockey`, agregar `-var usar_vockey=false`. Terraform crea una llave nueva en la carpeta `llaves/`.

## ✅ Cómo probarlo

Entrar a la central con el comando que muestra `comandos_ssh`:

```bash
ssh -i ~/.ssh/labsuser.pem ubuntu@<IP_PUBLICA_CENTRAL>
```

Desde la central:

```bash
ping <IP_PRIVADA_WH-001>   # responde ✅
ping <IP_PRIVADA_WH-002>   # responde ✅
ping <IP_PRIVADA_WH-003>   # responde ✅
```

Desde WH-001 (entrando por su IP pública):

```bash
ping <IP_PRIVADA_CENTRAL>  # responde ✅
ping <IP_PRIVADA_WH-002>   # no responde ❌
```

## 🧹 Borrar todo

```bash
terraform destroy -var-file=enviroments/terraform.tfvars
```
