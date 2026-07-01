# Terraform - Variable Definition Files

This document explains how Terraform variables are used to **decouple hardcoded values** from infrastructure code using separate variable definition files.

---

# Why Use Variable Definition Files?

Without variables:
- Values are hardcoded
- Difficult to manage across environments

With variables:
- Code becomes reusable
- Easy environment switching (dev / prod)
- Cleaner infrastructure design

---

# Base Code (Without Variables)

### variable-definition-file.tf

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
}
```

---

# Final Code (With Variables)

## variable-definition-file.tf

```hcl
resource "aws_instance" "myec2" {
  ami           = var.ami
  instance_type = "t2.micro"
}
```

---

## variables.tf

```hcl
variable "ami" {}
```

---

## terraform.tfvars

```hcl
ami = "ami-0e670eb768a5fc3d4"
```

---

# How It Works

Terraform loads variables in this order:

1. `variables.tf` → Declares variables
2. `terraform.tfvars` → Provides default values
3. CLI overrides (if provided)

---

# Example Flow

```text
var.ami
   ↓
terraform.tfvars
   ↓
ami = "ami-0e670eb768a5fc3d4"
```

---

# CLI Commands Used

## Initialize / Plan / Apply

```bash
terraform init
terraform plan
terraform apply
```

---

## Using Custom Variable File

```bash
terraform plan -var-file="prod.tfvars"
```

---

# File Structure

```text
.
├── variable-definition-file.tf
├── variables.tf
├── terraform.tfvars
└── prod.tfvars (optional)
```

---

# Key Concepts

## 1. Variables File (variables.tf)

Used to **declare variables**

```hcl
variable "ami" {}
```

---

## 2. tfvars File

Used to **assign values**

```hcl
ami = "ami-0e670eb768a5fc3d4"
```

---

## 3. Variable Reference

Used inside resources:

```hcl
var.ami
```

---

# Why This Approach is Important

- Supports multiple environments
- Avoids hardcoding AMIs
- Makes code reusable and scalable
- Improves DevOps best practices

---

# Real-World Usage

| Environment | File Used |
|------------|----------|
| Dev | terraform.tfvars |
| Prod | prod.tfvars |
| Test | test.tfvars |

---

# Summary

- `variables.tf` → defines variables
- `terraform.tfvars` → assigns values
- `var.<name>` → used inside resources
- `-var-file` → switches environments

---
