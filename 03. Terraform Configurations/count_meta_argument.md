# Terraform Count Meta-Argument

## Documentation Referred

Terraform Language Documentation:

https://developer.hashicorp.com/terraform/language/meta-arguments/count

---

# Overview

The **`count`** meta-argument allows Terraform to create multiple instances of the same resource.

Instead of writing the same resource block multiple times, you can use `count` to provision identical resources automatically.

Common use cases include:

- Creating multiple EC2 instances
- Creating multiple EBS volumes
- Creating multiple Security Groups
- Creating multiple Route Tables
- Creating multiple Subnets

---

# Syntax

```hcl
resource "<RESOURCE_TYPE>" "<RESOURCE_NAME>" {
  count = NUMBER
}
```

---

# Example 1 - Create a Single EC2 Instance

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
}
```

### Result

Terraform creates **one EC2 instance**.

```text
myec2
```

---

# Example 2 - Create Multiple EC2 Instances

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"

  count = 30
}
```

### Explanation

Terraform creates **30 EC2 instances** using the same configuration.

Internally, Terraform assigns an index to each resource.

```text
aws_instance.myec2[0]
aws_instance.myec2[1]
aws_instance.myec2[2]
...
aws_instance.myec2[29]
```

All instances have:

- Same AMI
- Same Instance Type
- Same Configuration

---

# Visual Representation

```text
Terraform

        count = 30
             │
             ▼

   ┌─────────────────────┐
   │ aws_instance.myec2  │
   └─────────────────────┘

             │

     Creates 30 EC2 Instances

myec2[0]
myec2[1]
myec2[2]
...
myec2[29]
```

> **Note:** Terraform uses the resource name (`myec2`) together with an index (`[0]`, `[1]`, etc.) to uniquely identify each resource in its state.

---

# Using Tags with Count

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"

  count = 30

  tags = {
    Name = "Development-Server"
  }
}
```

### Result

Terraform creates **30 EC2 instances**.

However, every instance receives the same tag:

```text
Development-Server
Development-Server
Development-Server
Development-Server
...
```

---

# Challenges with Count

Using `count` is simple, but it has limitations.

### 1. All Resources Are Identical

Every resource uses the same configuration.

Example:

- Same AMI
- Same Instance Type
- Same Tags

---

### 2. Difficult to Customize

Suppose you want:

```text
Web-Server
App-Server
Database-Server
```

Using `count` alone cannot assign different names to each instance.

---

### 3. Index-Based Management

Terraform identifies resources by index.

```text
myec2[0]
myec2[1]
myec2[2]
```

If the list changes, Terraform may destroy and recreate resources because the indexes shift.

---

# Example 3 - IAM User with Count

```hcl
resource "aws_iam_user" "lb" {
  name  = "sriram"
  count = 3
}
```

### What Happens?

Terraform attempts to create:

```text
sriram
sriram
sriram
```

This **fails** because AWS IAM usernames must be unique within an AWS account.

---

# Expected Error

The first user is created successfully.

When Terraform attempts to create the second user, AWS returns an error similar to:

```text
EntityAlreadyExists:
User with name sriram already exists.
```

---

# Why Does This Fail?

The `count` meta-argument duplicates the entire resource block.

It does **not** automatically generate unique values for attributes such as:

- IAM usernames
- S3 bucket names
- Route53 record names

If the resource requires a unique name, you must generate one yourself (for example, by using `count.index`).

---

# Common Resources That Work Well with Count

- EC2 Instances
- EBS Volumes
- Security Groups
- Network Interfaces
- Elastic IPs

These resources can often be duplicated without requiring unique names.

---

# Resources That Require Care

Some AWS resources require globally or account-wide unique names, such as:

- IAM Users
- S3 Buckets
- IAM Roles (within an account)
- CloudWatch Log Groups (depending on naming)

Using `count` with these resources without changing the name will result in duplicate name errors.

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

- What the **`count`** meta-argument is.
- Creating multiple EC2 instances using `count`.
- How Terraform indexes resources created with `count`.
- Using tags with multiple resources.
- Limitations of `count`.
- Why creating multiple IAM users with the same name fails.
- Common use cases and best practices for using `count`.
