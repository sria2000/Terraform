# Terraform Module Outputs

## Overview

Terraform **outputs** allow a child module to expose information to the root module or other modules.

Without outputs, resources created inside a module remain isolated and cannot be referenced outside the module.

Outputs make modules reusable by exposing only the values that other configurations need.

---

# Documentation

AWS Elastic IP Resource

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

---

# What are Module Outputs?

A module creates resources internally.

Sometimes another resource needs information from those resources, such as:

- EC2 Instance ID
- Public IP Address
- Private IP Address
- VPC ID
- Security Group ID
- ARN

Module outputs expose these values to the calling (root) module.

---

# Example Scenario

Suppose a child module creates an EC2 instance.

The root module then wants to associate an Elastic IP (EIP) with that EC2 instance.

Since the EC2 instance exists inside the child module, the root module cannot directly reference it.

Instead, the child module must expose the EC2 Instance ID using an **output**.

---

# Base Child Module

**modules/ec2/main.tf**

```terraform
resource "aws_instance" "myec2" {

  ami           = "ami-08a0d1e16fc3f61ea"

  instance_type = "t2.micro"

}
```

---

# Base Root Module

```terraform
provider "aws" {

  region = "us-east-1"

}

module "ec2" {

  source = "../../modules/ec2"

}

resource "aws_eip" "this" {

  domain = "vpc"

}
```

At this point, Terraform creates:

- One EC2 instance
- One Elastic IP

However, the Elastic IP is **not attached** to the EC2 instance because the root module has no knowledge of the EC2 Instance ID.

---

# Solution - Create an Output

Add an output to the child module.

## Child Module

```terraform
resource "aws_instance" "myec2" {

  ami           = "ami-08a0d1e16fc3f61ea"

  instance_type = "t2.micro"

}

output "instance_id" {

  value = aws_instance.myec2.id

}
```

The output exposes the EC2 Instance ID.

---

# Access the Output from the Root Module

The root module references the output using:

```terraform
module.<module-name>.<output-name>
```

General syntax:

```terraform
module.<module_name>.<output_name>
```

For this example:

```terraform
module.ec2.instance_id
```

---

# Final Root Module

```terraform
provider "aws" {

  region = "us-east-1"

}

module "ec2" {

  source = "../../modules/ec2"

}

resource "aws_eip" "this" {

  domain   = "vpc"

  instance = module.ec2.instance_id

}
```

Terraform now attaches the Elastic IP to the EC2 instance created inside the child module.

---

# How Outputs Work

```
               Root Module
                    │
                    │
          module "ec2"
                    │
                    ▼
             Child Module
                    │
          Creates EC2 Instance
                    │
                    ▼
        output "instance_id"
                    │
                    ▼
         module.ec2.instance_id
                    │
                    ▼
        AWS Elastic IP Resource
```

---

# Output Syntax

Basic syntax:

```terraform
output "output_name" {

  value = RESOURCE.ATTRIBUTE

}
```

Example:

```terraform
output "instance_id" {

  value = aws_instance.myec2.id

}
```

---

# Referencing Outputs

Inside the root module:

```terraform
module.ec2.instance_id
```

Syntax:

```terraform
module.<module_name>.<output_name>
```

---

# Common Resource Attributes Used in Outputs

| Resource | Common Output |
|-----------|---------------|
| EC2 | `id` |
| EC2 | `public_ip` |
| EC2 | `private_ip` |
| VPC | `id` |
| Subnet | `id` |
| Security Group | `id` |
| IAM Role | `arn` |
| Load Balancer | `dns_name` |

---

# Benefits of Module Outputs

- Share information between modules.
- Keep modules loosely coupled.
- Hide internal implementation details.
- Promote reusable module design.
- Simplify integration with other resources.
- Reduce duplicate resource lookups.

---

# Best Practices

- Output only the values required by other modules.
- Use meaningful output names.
- Keep outputs stable to avoid breaking dependent modules.
- Avoid exposing sensitive values unless necessary.
- Group outputs in a dedicated `outputs.tf` file for larger modules.

---

# Summary

Module outputs provide a mechanism for exposing resource information from a child module to the root module or other modules. In this example, the EC2 module exports the **Instance ID**, allowing the root module to associate an Elastic IP with the instance. Outputs are a fundamental feature for building modular, reusable, and maintainable Terraform configurations.
