# Terraform List and Map Data Types Example

## Documentation Referred

Terraform AWS Provider Documentation:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

---

# Overview

This example demonstrates how to use **List** and **Map** data types in Terraform variables.

- **List** stores multiple ordered values.
- **Map** stores data as key-value pairs.

These data types make Terraform configurations more reusable and easier to manage.

---

# Terraform Configuration

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-KEY"
  secret_key = "YOUR-KEY"
}

resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = var.list[1]
}

variable "list" {
  type = list

  default = [
    "m5.large",
    "m5.xlarge",
    "t2.medium"
  ]
}

variable "types" {
  type = map

  default = {
    us-east-1  = "t2.micro"
    us-west-2  = "t2.nano"
    ap-south-1 = "t2.small"
  }
}
```

---

# Provider Configuration

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-KEY"
  secret_key = "YOUR-KEY"
}
```

Connects Terraform to AWS.

| Parameter | Description |
|-----------|-------------|
| region | AWS Region |
| access_key | AWS Access Key |
| secret_key | AWS Secret Key |

> **Note:** For production environments, avoid hardcoding credentials. Use AWS CLI profiles, environment variables, or IAM roles.

---

# EC2 Resource

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = var.list[1]
}
```

Creates an EC2 instance.

The instance type is obtained from the **list variable**.

---

# List Variable

```hcl
variable "list" {
  type = list

  default = [
    "m5.large",
    "m5.xlarge",
    "t2.medium"
  ]
}
```

A list stores values in a specific order.

| Index | Value |
|------:|-------|
| 0 | m5.large |
| 1 | m5.xlarge |
| 2 | t2.medium |

---

# Accessing List Elements

Terraform lists use **zero-based indexing**.

```hcl
var.list[0]
```

Returns:

```text
m5.large
```

```hcl
var.list[1]
```

Returns:

```text
m5.xlarge
```

```hcl
var.list[2]
```

Returns:

```text
t2.medium
```

Since the EC2 resource uses:

```hcl
instance_type = var.list[1]
```

Terraform launches the instance using:

```text
m5.xlarge
```

---

# Visual Representation

```text
List

Index      Value
-----      -------------
0      ->  m5.large
1      ->  m5.xlarge
2      ->  t2.medium

            │
            ▼

instance_type = var.list[1]

            │
            ▼

m5.xlarge
```

---

# Map Variable

```hcl
variable "types" {
  type = map

  default = {
    us-east-1  = "t2.micro"
    us-west-2  = "t2.nano"
    ap-south-1 = "t2.small"
  }
}
```

A map stores **key-value pairs**.

| Key | Value |
|-----|-------|
| us-east-1 | t2.micro |
| us-west-2 | t2.nano |
| ap-south-1 | t2.small |

---

# Accessing Map Values

Use the key name to retrieve a value.

```hcl
var.types["us-east-1"]
```

Returns:

```text
t2.micro
```

```hcl
var.types["us-west-2"]
```

Returns:

```text
t2.nano
```

```hcl
var.types["ap-south-1"]
```

Returns:

```text
t2.small
```

---

# Example Using the Map Variable

Instead of using the list, you could write:

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = var.types["us-west-2"]
}
```

Terraform selects:

```text
t2.nano
```

---

# List vs Map

| Feature | List | Map |
|---------|------|-----|
| Stores | Ordered values | Key-value pairs |
| Access | Index | Key |
| Example | `["A","B","C"]` | `{Name="Sri"}` |
| First Element | `list[0]` | Not applicable |
| Typical Use | Security Groups, Subnets | Tags, Regions, Configuration |

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

# Best Practices

- Use **lists** when the order of values matters.
- Use **maps** when values should be accessed by a meaningful key.
- Prefer `list(string)` over `list` for stronger type validation.
- Prefer `map(string)` over `map` to ensure all values are strings.
- Never hardcode AWS credentials in Terraform configuration files. Use IAM roles, AWS CLI profiles, or environment variables instead.

---

# Summary

This example demonstrated:

- Creating a **List** variable.
- Accessing list elements using indexes.
- Creating a **Map** variable.
- Accessing map values using keys.
- Using list values as EC2 instance types.
- How lists and maps differ and when to use each.
