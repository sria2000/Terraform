# Terraform Data Types and AWS EC2 Instance Resource

## Documentation Referred

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

------------------------------------------------------------------------

## Overview

This document covers Terraform variable data types, variable
restrictions, and AWS EC2 instance resource creation using Terraform.

## Variable Data Type Example

### Base Code Used in Video

``` hcl
resource "aws_iam_user" "lb" {
  name = "loadbalancer"
}
```

### Variable with Data Type Restriction

``` hcl
variable "username" {
  type = number
}

resource "aws_iam_user" "lb" {
  name = var.username
}
```

The variable is restricted to accept only numeric values.

## AWS EC2 Instance Example

``` hcl
resource "aws_instance" "web" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-06dc77ed59c310f03"]
}
```

## EC2 Configuration Details

  -----------------------------------------------------------------------
  Parameter                           Description
  ----------------------------------- -----------------------------------
  ami                                 Amazon Machine Image used to launch
                                      the instance

  instance_type                       Defines EC2 compute capacity

  vpc_security_group_ids              Associates security groups with the
                                      instance
  -----------------------------------------------------------------------

## Terraform Commands

### Initialize

``` bash
terraform init
```

### Validate

``` bash
terraform validate
```

### Plan

``` bash
terraform plan
```

### Apply

``` bash
terraform apply
```

### Destroy

``` bash
terraform destroy
```

## Summary

This example demonstrates:

-   Terraform variable type restrictions.
-   Using variables inside resources.
-   Creating AWS IAM resources.
-   Creating AWS EC2 instances.
-   Managing AWS infrastructure using Terraform.
