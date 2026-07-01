# Terraform - Variables (Infrastructure as Code)

This document explains how **Terraform variables** are used to make infrastructure dynamic, reusable, and easier to manage.

---

# Why Use Variables?

Without variables, we hardcode values like:

- IP addresses
- Ports
- Environment settings

With variables, we can:
- Reuse code
- Avoid repetition
- Manage environments easily (dev / prod / staging)
- Improve security and flexibility

---

# Documentation Reference

https://registry.terraform.io/language/values/variables

---

# 1. Base Code (Without Variables)

### terraform-variables.tf (Before Optimization)

```hcl
resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall"
  description = "Managed from Terraform"
}

resource "aws_vpc_security_group_ingress_rule" "app_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "101.20.30.50/32"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "ssh_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "101.20.30.50/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ftp_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "101.20.30.50/32"
  from_port         = 21
  ip_protocol       = "tcp"
  to_port           = 21
}
```

---

# 2. Final Code (With Variables)

## terraform-variables.tf

```hcl
resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall"
  description = "Managed from Terraform"
}

resource "aws_vpc_security_group_ingress_rule" "app_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.app_port
  ip_protocol       = "tcp"
  to_port           = var.app_port
}

resource "aws_vpc_security_group_ingress_rule" "ssh_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "ftp_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.ftp_port
  ip_protocol       = "tcp"
  to_port           = var.ftp_port
}
```

---

# 3. variables.tf

```hcl
variable "vpn_ip" {
  default     = "200.20.30.50/32"
  description = "This is a VPN Server Created in AWS"
}

variable "app_port" {
  default = "8080"
}

variable "ssh_port" {
  default = "22"
}

variable "ftp_port" {
  default = "21"
}
```

---

# Key Concepts

## 1. What is a Variable?

A variable is a **placeholder for values** used in Terraform configurations.

Example:
```hcl
var.vpn_ip
```

---

## 2. Benefits of Variables

- Avoid hardcoding values
- Improve reuse
- Easy environment changes
- Cleaner code structure

---

## 3. How Variables Work

Terraform replaces:

```hcl
var.vpn_ip
```

with:

```text
200.20.30.50/32
```

during execution.

---

# CLI Commands Used

```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

# Before vs After

| Before (Hardcoded) | After (Variables) |
|--------------------|------------------|
| Fixed IP address | Dynamic IP (`var.vpn_ip`) |
| Repeated values | Reusable variables |
| Hard to maintain | Easy to update |

---

# Real-World Use Case

Variables are commonly used for:

- Multiple environments (dev / test / prod)
- Different IP whitelisting
- Dynamic port configurations
- Reusable modules

---

# Summary

- Terraform variables make infrastructure dynamic
- Defined in `variables.tf`
- Accessed using `var.<name>`
- Improve scalability and maintainability

---
