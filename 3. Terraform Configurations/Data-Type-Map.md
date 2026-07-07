# Terraform Data Type - Map

## Documentation Referred

Terraform AWS Provider Documentation:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

---

# Overview

A **Map** is a collection of **key-value pairs**.

Each value is associated with a unique key, making it easy to store and retrieve related information.

One of the most common uses of the **map** data type in AWS is for **resource tags**.

Example AWS Tags:

```text
Name = WebServer
Environment = Production
Owner = DevOps
```

---

# Syntax

```hcl
variable "variable_name" {
  type = map
}
```

---

# Example 1 - Base Code

## map-data-type.tf

```hcl
variable "my-map" {
  type = map
}

output "variable_value" {
  value = var.my-map
}
```

### Explanation

- The variable accepts a map.
- No default value is provided.
- Terraform prompts the user to enter a value during execution.

Example input:

```text
{
  Name = "Sri"
  Team = "Terraform"
}
```

---

# Example 2 - Map with Default Values

## map-data-type.tf

```hcl
variable "my-map" {
  type = map

  default = {
    Name = "Alice"
    Team = "Payments"
  }
}

output "variable_value" {
  value = var.my-map
}
```

### Explanation

- The variable is of type `map`.
- Two key-value pairs are defined as default values.
- Terraform uses these values automatically unless overridden.

Default map:

| Key | Value |
|-----|-------|
| Name | Alice |
| Team | Payments |

---

# Example 3 - Map Variable

```hcl
variable "sri_map" {
  type = map

  default = {
    Name = "Sri"
    Team = "TF Consultant"
  }
}

output "variable_name" {
  value = var.sri_map
}
```

### Output

```text
PS D:\Terraform\TERRAFORMLAB> terraform plan

Changes to Outputs:
  + variable_name = {
      + Name = "Sri"
      + Team = "TF Consultant"
    }
```

---

# Understanding a Map

A map stores data as **Key → Value** pairs.

```text
Name  ─────► Sri
Team  ─────► TF Consultant
```

Unlike a list, map elements are accessed using their keys.

---

# Accessing Individual Values

You can access a specific value using its key.

Example:

```hcl
output "employee_name" {
  value = var.sri_map["Name"]
}

output "employee_team" {
  value = var.sri_map["Team"]
}
```

Output:

```text
employee_name = "Sri"
employee_team = "TF Consultant"
```

---

# Common Uses of Maps

Maps are commonly used for:

- AWS Tags
- Environment Variables
- Application Configuration
- Department Information
- Resource Metadata

Example:

```hcl
variable "tags" {
  type = map(string)

  default = {
    Environment = "Dev"
    Owner       = "Terraform"
    Project     = "AWS"
  }
}
```

---

# AWS Tags Example

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t3.micro"

  tags = {
    Name        = "WebServer"
    Environment = "Production"
    Team        = "DevOps"
  }
}
```

Resulting AWS Tags:

| Tag | Value |
|-----|-------|
| Name | WebServer |
| Environment | Production |
| Team | DevOps |

---

# Map vs List

| List | Map |
|------|-----|
| Stores ordered values | Stores key-value pairs |
| Access by index | Access by key |
| Example: `["A","B","C"]` | Example: `{Name="Sri", Team="TF"}` |

---

# Best Practice

Instead of:

```hcl
variable "tags" {
  type = map
}
```

Prefer:

```hcl
variable "tags" {
  type = map(string)
}
```

This ensures all values in the map are strings, providing better type validation.

---

# Terraform Commands

## Initialize

```bash
terraform init
```

## Validate

```bash
terraform validate
```

## Create Execution Plan

```bash
terraform plan
```

## Apply Configuration

```bash
terraform apply
```

## Destroy Resources

```bash
terraform destroy
```

---

# Summary

This document demonstrated:

- What a **Map** data type is.
- Creating map variables.
- Using default values.
- Displaying map values with outputs.
- Accessing map values using keys.
- Using maps for AWS Tags.
- Difference between **List** and **Map**.
- Best practices using `map(string)`.
