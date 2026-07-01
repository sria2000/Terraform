# Terraform - Basics of Attributes & Cross-Resource References

This document explains the **basics of Terraform resource attributes** and how to use **cross-resource referencing** between AWS resources.

---

# 1. Basics of Attributes

## What are Terraform Attributes?

Attributes are **values exposed by resources after creation**.  
They allow you to reference data from one resource inside another resource.

Example:
- EC2 instance public IP
- Elastic IP address
- Instance ID
- Security Group ID

---

## Documentation Referred

### AWS Elastic IP
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

### AWS EC2 Instance
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

---

## File: attributes.tf

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "lb" {
  domain = "vpc"
}

resource "aws_instance" "web" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
}
```

---

## Terraform Commands Used

```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

## Understanding Attributes (Examples)

After creation, Terraform exposes attributes like:

### EC2 Instance Attributes
```hcl
aws_instance.web.id
aws_instance.web.public_ip
aws_instance.web.private_ip
```

### Elastic IP Attributes
```hcl
aws_eip.lb.public_ip
aws_eip.lb.id
aws_eip.lb.allocation_id
```

---

## Key Concept

Attributes allow you to:
- Share values between resources
- Build dependencies automatically
- Avoid hardcoding values

---

# 2. Cross Resource Attributes (Cross-Reference)

## What is Cross-Referencing?

Cross-referencing means using **output/attribute of one resource inside another resource**.

Terraform automatically creates dependencies when attributes are referenced.

---

## Documentation Referred

### AWS Elastic IP
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

### AWS EC2 Instance
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

### Security Group Rules
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

---

## File: cross-reference-attributes.tf

```hcl
resource "aws_eip" "lb" {
  domain = "vpc"
}

resource "aws_security_group" "example" {
  name = "attribute-sg"
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = "${aws_eip.lb.public_ip}/32"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}
```

---

## Explanation of Cross Reference

### 1. Elastic IP
```hcl
aws_eip.lb.public_ip
```

This fetches the **public IP address** of the Elastic IP resource.

---

### 2. Security Group ID Reference
```hcl
aws_security_group.example.id
```

This ensures Terraform:
- Creates the security group first
- Then attaches the rule to it

---

### 3. Dynamic CIDR Block

```hcl
cidr_ipv4 = "${aws_eip.lb.public_ip}/32"
```

This means:
- Allow HTTPS (443)
- Only from the Elastic IP created earlier
- `/32` = single IP address

---

## Why Cross-Reference is Important

- Removes hardcoded IPs
- Creates dependency automatically
- Makes infrastructure dynamic
- Improves maintainability

---

## Terraform Commands Used

```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

# Key Takeaways

- Attributes are values exposed after resource creation
- You can reference them using:
  ```hcl
  resource_type.resource_name.attribute
  ```
- Cross-resource referencing builds dependency automatically
- Terraform ensures correct creation order

---

# Summary

| Concept | Example |
|----------|--------|
| Attribute | `aws_eip.lb.public_ip` |
| Resource ID | `aws_security_group.example.id` |
| Cross Reference | `"${aws_eip.lb.public_ip}/32"` |

---
