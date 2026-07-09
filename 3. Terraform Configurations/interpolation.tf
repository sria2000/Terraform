# Terraform String Interpolation and Resource References

## Overview

Terraform **String Interpolation** allows you to dynamically reference values from variables, resources, data sources, and built-in functions instead of hardcoding them.

This makes Terraform configurations:

- Dynamic
- Reusable
- Easier to maintain
- Less error-prone

In this example, a **Security Group** automatically uses the **public IP address of an Elastic IP (EIP)** instead of manually entering it.

---

# Base Configuration

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "PUT-YOUR-ACCESS-KEY-HERE"
  secret_key = "PUT-YOUR-SECRET-KEY-HERE"
}

resource "aws_eip" "myeip" {
   domain = "vpc"
}

resource "aws_security_group" "allow_all" {
  name = "interpolation-demo"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = [
      "${aws_eip.myeip.public_ip}/32"
    ]
  }
}
```

---

# Understanding the Configuration

The configuration creates two AWS resources:

```
Elastic IP

↓

Security Group
```

The Security Group automatically allows traffic **only from the Elastic IP address** created by Terraform.

---

# Step 1 - Create an Elastic IP

```hcl
resource "aws_eip" "myeip" {

   domain = "vpc"

}
```

This creates an AWS Elastic IP.

Example AWS assigns:

```
18.12.30.50
```

Terraform stores this information in its state.

Available attributes include:

```
aws_eip.myeip.id

aws_eip.myeip.public_ip

aws_eip.myeip.private_ip

aws_eip.myeip.allocation_id
```

One of those attributes is:

```
aws_eip.myeip.public_ip
```

Example value:

```
18.12.30.50
```

---

# Step 2 - Create a Security Group

Terraform then creates:

```hcl
resource "aws_security_group" "allow_all" {
```

Inside the Security Group is an ingress rule.

```hcl
ingress {

    from_port = 0

    to_port = 0

    protocol = "-1"

}
```

Meaning:

```
Allow every protocol

Allow every port
```

---

# Understanding the CIDR Block

The important line is:

```hcl
cidr_blocks = [
  "${aws_eip.myeip.public_ip}/32"
]
```

Terraform evaluates:

```
aws_eip.myeip.public_ip
```

Suppose AWS returned:

```
18.12.30.50
```

Terraform replaces the interpolation with:

```
18.12.30.50/32
```

Therefore the Security Group becomes:

```text
Source:

18.12.30.50/32
```

---

# What Does `/32` Mean?

CIDR notation specifies the network size.

```
18.12.30.50/32
```

means:

```
Exactly one IP address
```

Only:

```
18.12.30.50
```

is allowed.

---

# CIDR Comparison

| CIDR | Addresses Allowed |
|------|-------------------|
| /32 | 1 IP Address |
| /24 | 256 IP Addresses |
| /16 | 65,536 IP Addresses |
| 0.0.0.0/0 | Entire Internet |

---

# How String Interpolation Works

The syntax is:

```hcl
"${expression}"
```

Terraform evaluates the expression before sending the request to AWS.

Example:

```
"${aws_eip.myeip.public_ip}"
```

↓

Terraform reads:

```
18.12.30.50
```

↓

Final value:

```
18.12.30.50/32
```

---

# Resource Reference Syntax

Terraform references follow this format:

```text
<Resource Type>.<Resource Name>.<Attribute>
```

Example:

```hcl
aws_eip.myeip.public_ip
```

Breakdown:

| Component | Value |
|-----------|-------|
| Resource Type | aws_eip |
| Resource Name | myeip |
| Attribute | public_ip |

---

# Execution Flow

```
Terraform Apply

       │

       ▼

Create Elastic IP

       │

       ▼

AWS returns

18.12.30.50

       │

       ▼

Terraform reads

aws_eip.myeip.public_ip

       │

       ▼

Creates Security Group

       │

       ▼

CIDR becomes

18.12.30.50/32
```

---

# Implicit Dependency

Notice that the Security Group references:

```hcl
aws_eip.myeip.public_ip
```

Terraform automatically knows:

```
Elastic IP

      │

      ▼

Security Group
```

This is called an **Implicit Dependency**.

No `depends_on` block is required because Terraform automatically builds the dependency graph.

---

# Old vs New Interpolation Syntax

### Older Syntax

```hcl
"${aws_eip.myeip.public_ip}"
```

### Modern Terraform (Recommended)

Terraform 0.12 and later no longer require interpolation when assigning a single value.

Instead write:

```hcl
cidr_blocks = [
  "${aws_eip.myeip.public_ip}/32"
]
```

or, even better using string interpolation only where needed:

```hcl
cidr_blocks = [
  "${aws_eip.myeip.public_ip}/32"
]
```

Since `/32` must be appended to the IP address, interpolation is still appropriate here. If you were assigning only the attribute itself, you could simply use:

```hcl
public_ip = aws_eip.myeip.public_ip
```

---

# Why Use Resource References?

Without interpolation:

```hcl
cidr_blocks = [
  "18.12.30.50/32"
]
```

Problems:

- Hardcoded IP
- Must manually edit if IP changes
- Error-prone
- Difficult to automate

With interpolation:

```hcl
cidr_blocks = [
  "${aws_eip.myeip.public_ip}/32"
]
```

Benefits:

- Automatically updated
- Dynamic
- Easier to maintain
- No manual changes

---

# Real-World Use Cases

Resource references are commonly used for:

- EC2 → Security Groups
- EC2 → Elastic IP
- Subnets → VPC IDs
- Route Tables → Gateway IDs
- Load Balancers → Target Groups
- IAM Roles → EC2 Instances
- RDS → Security Groups

---

# Common Resource Attributes

Some frequently used attributes include:

| Resource | Attribute |
|----------|-----------|
| EC2 | `id` |
| EC2 | `public_ip` |
| EC2 | `private_ip` |
| Security Group | `id` |
| VPC | `id` |
| Subnet | `id` |
| Elastic IP | `public_ip` |
| IAM User | `arn` |
| S3 Bucket | `bucket` |

---

# Best Practices

- Prefer resource references over hardcoded values.
- Let Terraform build the dependency graph automatically.
- Use implicit dependencies whenever possible.
- Avoid unnecessary `depends_on` blocks.
- Use interpolation to construct dynamic strings (such as appending `/32` to an IP address).

---

# Summary

| Feature | Description |
|---------|-------------|
| String Interpolation | Dynamically inserts values into strings. |
| Resource Reference | Accesses attributes of another Terraform resource. |
| Implicit Dependency | Terraform automatically determines resource creation order. |
| `/32` CIDR | Restricts access to a single IP address. |

---

# Key Takeaways

- String interpolation allows Terraform to dynamically build configuration values.
- Resource references follow the format `<resource_type>.<resource_name>.<attribute>`.
- In this example, the Security Group automatically uses the Elastic IP address created by Terraform.
- Because the Security Group references the Elastic IP, Terraform creates the Elastic IP first and then the Security Group.
- Using resource references makes Terraform configurations more dynamic, reusable, and easier to maintain.
