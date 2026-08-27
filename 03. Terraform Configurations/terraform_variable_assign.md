# Terraform - Variable Assignment Methods

This document explains different ways to **pass variables to Terraform**, including CLI arguments and environment variables.

---

# Base Code

### variable-assignment.tf

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
}
```

---

# 1. CLI Variable Assignment

Terraform allows you to override variables directly from the command line.

### Example:

```bash
terraform plan -var="instance_type=m5.large"
```

---

## How it Works

- Overrides default or tfvars values
- Highest priority during execution
- Useful for quick testing

---

## Example (with variable support)

If your code is updated like this:

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = var.instance_type
}
```

Then CLI override works:

```bash
terraform plan -var="instance_type=m5.large"
```

---

# 2. Environment Variables (Windows)

Terraform also supports environment variables.

---

## Step 1: Open System Properties

Run:

```text
sysdm.cpl
```

Then:
- Go to **Advanced**
- Click **Environment Variables**

---

## Step 2: Set Terraform Variables

Create variables using this format:

```text
TF_VAR_<variable_name>
```

### Example:

```text
TF_VAR_instance_type = m5.large
```

---

## Step 3: Verify in Terraform

Terraform automatically picks it up:

```hcl
variable "instance_type" {}
```

---

# 3. Environment Variables (Linux / UNIX)

On Linux or macOS:

```bash
export TF_VAR_instance_type="m5.large"
```

Verify:

```bash
echo $TF_VAR_instance_type
```

Run Terraform:

```bash
terraform plan
```

---

# Variable Precedence (Important)

Terraform uses the following priority order:

1. CLI `-var`
2. `terraform.tfvars`
3. `*.auto.tfvars`
4. Environment variables (`TF_VAR_*`)
5. Default values in `variables.tf`

---

# Key Concepts

## 1. CLI Variables
- Used for quick overrides
- Example:
```bash
-var="instance_type=m5.large"
```

---

## 2. Environment Variables
- Useful in CI/CD pipelines
- No need to modify code
- Secure for automation

---

## 3. Hardcoded Values (Avoid)

```hcl
instance_type = "t2.micro"
```

---

# Real-World Use Case

| Method | Use Case |
|--------|----------|
| CLI `-var` | Testing / debugging |
| tfvars file | Environment-based configs |
| Environment variables | CI/CD pipelines |
| Hardcoded | Not recommended |

---

# Summary

- Terraform supports multiple variable injection methods
- CLI variables have highest priority
- Environment variables use `TF_VAR_` prefix
- Best practice is to avoid hardcoding values

---
