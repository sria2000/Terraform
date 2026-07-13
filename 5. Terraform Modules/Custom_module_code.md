# Terraform Module Best Practices – Eliminating Hardcoded Values

# Overview

A Terraform module should be reusable across different environments and AWS regions.

A common mistake when creating custom modules is **hardcoding values** such as:

- AWS Region
- AMI ID
- Instance Type
- Provider Configuration

Hardcoded values make modules difficult to reuse and maintain.

This guide demonstrates how to improve a custom Terraform module by replacing hardcoded values with variables and following Terraform provider best practices.

---

# Documentation

Terraform Provider Requirements

https://developer.hashicorp.com/terraform/language/providers/requirements

AWS Provider Documentation

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

---

# Initial Module (Not Recommended)

```terraform
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-1234"
  instance_type = "t2.micro"
}
```

---

# Challenges

## Challenge 1 – Hardcoded Values

The following values are fixed inside the module:

- Region
- AMI ID
- Instance Type

This means every project receives the same configuration.

Changing any value requires editing the module itself.

---

## Challenge 2 – Hardcoded Provider

The AWS provider is also fixed.

```terraform
provider "aws" {
  region = "us-east-1"
}
```

Different environments may require different regions:

- eu-west-1
- us-east-1
- ap-south-1

A reusable module should not force a specific provider configuration.

---

# Improvement 1 – Replace Hardcoded Values with Variables

Instead of hardcoding values, use input variables.

## Improved Module

```terraform
provider "aws" {
  region = var.region
}

resource "aws_instance" "myec2" {
  ami           = var.ami
  instance_type = var.instance_type
}

variable "ami" {}

variable "instance_type" {}

variable "region" {}
```

The module is now reusable.

---

# Calling the Module

```terraform
module "ec2" {

  source = "../../modules/ec2"

  ami            = "ami-123"

  instance_type  = "t2.large"

  region         = "ap-south-1"

}
```

The calling project now supplies the required values.

---

# Example

## Module

**modules/ec2/ec2.tf**

```terraform
provider "aws" {
  region = var.region
}

resource "aws_instance" "myec2" {
  ami           = var.ami
  instance_type = var.instance_type
}

variable "ami" {}

variable "instance_type" {}

variable "region" {}
```

---

## Calling Module

**teams/A/module.tf**

```terraform
module "ec2" {

  source = "../../modules/ec2"

  ami            = "ami-0d0463f1527996442"

  instance_type  = "t2.micro"

  region         = "eu-west-1"

}
```

---

# Initialize Terraform

```bash
terraform init
```

Example:

```text
Terraform has been successfully initialized!
```

Terraform can now deploy the infrastructure using values supplied by the caller.

---

# Improvement 2 – Remove the Provider from the Module

Although passing the region as a variable works, Terraform recommends **not configuring providers inside reusable modules**.

Instead, define provider requirements using the `required_providers` block.

---

# Improved Module (Recommended)

```terraform
terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = ">= 5.50"

    }

  }

}

resource "aws_instance" "myec2" {

  ami           = var.ami

  instance_type = var.instance_type

}

variable "ami" {}

variable "instance_type" {}
```

Notice that the provider block has been removed.

The module now simply declares which provider it requires.

---

# Provider Configuration in the Calling Project

The root module is responsible for configuring the provider.

```terraform
provider "aws" {

  region = "eu-west-1"

}

module "ec2" {

  source = "../../modules/ec2"

  ami            = "ami-0d0463f1527996442"

  instance_type  = "t2.micro"

}
```

This is the recommended Terraform design.

---

# Why is This Better?

## Before

```
Module

├── Provider
├── Region
├── AMI
└── Instance Type
```

Everything was hardcoded.

---

## After

```
Root Module
│
├── Provider Configuration
├── Region
├── AMI
└── Instance Type
        │
        ▼
Reusable Module
        │
        ▼
Creates EC2 Instance
```

The reusable module contains only infrastructure logic.

The calling project controls environment-specific values.

---

# Benefits

- Reusable across environments
- No hardcoded values
- Easier maintenance
- Better separation of responsibilities
- Supports multiple AWS regions
- Compatible with production environments
- Easier to test
- Follows Terraform best practices

---

# Best Practices

✔ Replace hardcoded values with variables.

✔ Keep reusable modules environment independent.

✔ Configure providers only in the root module.

✔ Use `required_providers` to specify provider source and version.

✔ Pin provider versions to avoid unexpected upgrades.

✔ Keep modules focused on a single purpose.

✔ Use variables and outputs to maximize reusability.

---

# Summary

A well-designed Terraform module should be portable, reusable, and independent of any specific environment. By replacing hardcoded values with variables and moving provider configuration to the root module while using the `required_providers` block, you create modules that are easier to maintain, more flexible, and aligned with Terraform best practices for production deployments.
