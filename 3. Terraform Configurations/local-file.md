# Terraform Local Values

## Use of Variables

# Local Values

Local values are similar to variables in a sense that they allow you to store data centrally and that data can be referenced in multiple parts of the Terraform configuration.

Local values help to avoid repeating the same values multiple times in Terraform code.

---

# Documentation Referred

Terraform Format Date Function:

https://developer.hashicorp.com/terraform/language/functions/formatdate

---

# Base Code: local-values.tf

```hcl
resource "aws_security_group" "sg_01" {

  name = "app_firewall"

  tags = {
    Name = "security-team"
  }

}


resource "aws_security_group" "sg_02" {

  name = "db_firewall"

  tags = {
    Name = "security-team"
  }

}
```

---

# Problem

The above configuration contains a common value:

```
security-team
```

This value is repeated in multiple resources.

If the value needs to be changed in the future, we need to update every resource manually.

To solve this problem, we can use:

- Variables
- Local Values

---

# Example 1: Using Variables

## Variable Definition

```hcl
variable "tag" {

  type = map

  default = {

    Team = "security-team"

  }

}
```

---

## Using Variable in Resources

```hcl
resource "aws_security_group" "sg_01" {

  name = "app_firewall"

  tags = var.tag

}


resource "aws_security_group" "sg_02" {

  name = "db_firewall"

  tags = var.tag

}
```

---

## Explanation

The value:

```
Team = security-team
```

is stored centrally inside the variable.

Both security groups can reuse the same value using:

```hcl
tags = var.tag
```

---

# Example 2: Using Local Variables

Local values store reusable values inside Terraform configuration.

## Local Value Definition

```hcl
locals {

  default = {

    Team = "security-team"

  }

}
```

---

## Using Local Values in Resources

```hcl
resource "aws_security_group" "sg_01" {

  name = "app_firewall"

  tags = local.default

}


resource "aws_security_group" "sg_02" {

  name = "db_firewall"

  tags = local.default

}
```

---

## Explanation

The local value is referenced using:

```hcl
local.default
```

Both resources receive:

```
Team = security-team
```

---

# Locals Benefits

One major benefit of locals is that they support expressions.

Expressions allow Terraform to calculate values dynamically.

---

# Example: Dynamic Local Values

```hcl
variable "tags" {

  type = map

  default = {

    Team = "security-team"

  }

}


locals {

  default = {

    Team = "security-team"

    CreationDate = "date-${formatdate("DDMMYYYY",timestamp())}"

  }

}
```

---

# Using Dynamic Local Values

```hcl
resource "aws_security_group" "sg_01" {

  name = "app_firewall"

  tags = local.default

}


resource "aws_security_group" "sg_02" {

  name = "db_firewall"

  tags = local.default

}
```

---

# Dynamic Value Output Example

Terraform dynamically generates:

```
Team = security-team

CreationDate = date-07072026
```

The creation date is generated using:

```hcl
formatdate("DDMMYYYY",timestamp())
```

---

# Local Values vs Variables

## Variables

Variable values can be defined in multiple places:

### 1. terraform.tfvars

Example:

```hcl
region = "us-east-1"
```

---

### 2. Environment Variables

Example:

```bash
export TF_VAR_region="us-east-1"
```

---

### 3. Command Line Arguments

Example:

```bash
terraform apply -var="region=us-east-1"
```

---

# Local Values

Local values are private to the Terraform configuration.

They are mainly used for:

- Internal reusable values
- Calculated values
- Avoiding duplication
- Improving readability

---

# Difference Between Variables and Local Values

| Feature | Variables | Local Values |
|---|---|---|
| Purpose | Accept external input | Store internal values |
| Scope | Module input | Private module value |
| Can be overridden | Yes | No |
| terraform.tfvars support | Yes | No |
| Environment variable support | Yes | No |
| CLI override | Yes | No |
| Definition | `variable` block | `locals` block |
| Reference | `var.name` | `local.name` |

---

# Important Notes

## Note 1: Local Values Name

Local values are often referred to as:

```
locals
```

---

## Note 2: Creation vs Reference

Local values are created using the **plural** keyword:

```hcl
locals {

}
```

Example:

```hcl
locals {

  environment = "production"

}
```

---

But local values are referenced using the **singular** keyword:

```hcl
local.environment
```

Example:

```hcl
tags = local.default
```

---

# Summary

| Terraform Feature | Description |
|---|---|
| Variables | Used for values provided externally |
| Local Values | Used for internal reusable values |
| `var.name` | Access variable values |
| `local.name` | Access local values |
| `timestamp()` | Returns current timestamp |
| `formatdate()` | Formats timestamp output |

---

# Key Interview Point

**Variables are used when values need to be supplied from outside Terraform.**

**Local values are used when values are created, calculated, and reused inside Terraform configuration.**
