# Terraform State Management

## Overview

Terraform uses a **state file** to keep track of the infrastructure it manages.

Without the state file, Terraform would have no way of knowing:

- Which resources it has already created.
- The current attributes of those resources.
- What changes are required during the next `terraform plan` or `terraform apply`.

State management is one of the most important concepts in Terraform because it acts as the **source of truth** for your infrastructure.

---

# What is a Terraform State File?

Terraform stores information about managed infrastructure in a file called:

```text
terraform.tfstate
```

This file contains metadata about every resource Terraform manages.

For example:

- EC2 Instance IDs
- Security Group IDs
- Elastic IPs
- IAM User ARNs
- VPC IDs
- Public IP Addresses
- Resource Dependencies

Terraform compares:

```text
Terraform Configuration (.tf files)

            VS

Terraform State

            VS

Actual Infrastructure
```

to determine what actions need to be performed.

---

# Why Does Terraform Need State?

Suppose you create an EC2 instance.

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"
}
```

After running:

```bash
terraform apply
```

AWS returns:

```
Instance ID

i-0123456789abcdef0
```

Terraform stores this ID in the state file.

Without the state file, Terraform would not know:

- Which EC2 instance belongs to this configuration.
- Whether it already exists.
- Whether it needs to update or recreate it.

---

# Local vs Remote State

## Local State

By default, Terraform stores state locally:

```text
terraform.tfstate
```

Advantages:

- Simple
- Easy to get started

Disadvantages:

- Cannot easily share with a team.
- Risk of accidental deletion.
- No locking.
- Difficult to collaborate.

---

## Remote State

Terraform can store the state remotely.

Common backends include:

- Amazon S3
- Azure Storage
- Google Cloud Storage
- HCP Terraform
- Terraform Enterprise

Benefits:

- Shared by all team members.
- Centralized storage.
- Better collaboration.
- Supports state locking (with DynamoDB for S3).
- Improved security and backup options.

---

# Example Configuration

## `state-management.tf`

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

resource "aws_instance" "myec2" {

  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"

}

resource "aws_iam_user" "lb" {

  name = "loadbalancer"

  path = "/system/"

}

terraform {

  backend "s3" {

    bucket = "kplabs-remote-backends"

    key = "demo.tfstate"

    region = "us-east-1"

    access_key = "YOUR-ACCESS-KEY"

    secret_key = "YOUR-SECRET-KEY"

  }

}
```

---

# Understanding the Provider Block

```hcl
provider "aws" {

  region = "us-west-2"

}
```

This tells Terraform:

- Which cloud provider to use.
- Which AWS region to deploy resources into.

The EC2 instance and IAM user will be created using this provider configuration.

---

# Resources Created

This configuration creates two AWS resources.

## EC2 Instance

```hcl
resource "aws_instance" "myec2" {

  ami = "ami-082b5a644766e0e6f"

  instance_type = "t2.micro"

}
```

Creates:

```
Amazon EC2 Instance
```

---

## IAM User

```hcl
resource "aws_iam_user" "lb" {

  name = "loadbalancer"

}
```

Creates:

```
IAM User

loadbalancer
```

---

# Backend Configuration

The most important section is:

```hcl
terraform {

  backend "s3" {

    bucket = "kplabs-remote-backends"

    key = "demo.tfstate"

    region = "us-east-1"

  }

}
```

This tells Terraform:

> Store the Terraform state inside an Amazon S3 bucket instead of on the local machine.

---

# Backend Parameters

## bucket

```hcl
bucket = "kplabs-remote-backends"
```

The S3 bucket where the state file is stored.

Example:

```
kplabs-remote-backends
```

---

## key

```hcl
key = "demo.tfstate"
```

The path (object name) inside the bucket.

Result:

```
S3 Bucket

└── demo.tfstate
```

---

## region

```hcl
region = "us-east-1"
```

The region where the S3 bucket exists.

Notice:

| Resource | Region |
|----------|--------|
| EC2 | us-west-2 |
| State Bucket | us-east-1 |

These regions **do not have to be the same**.

---

# State File Architecture

```text
Terraform Configuration

          │

          ▼

Terraform Apply

          │

          ▼

AWS Resources

          │

          ▼

Terraform State

          │

          ▼

Amazon S3 Bucket
```

---

# Initializing the Backend

Whenever a backend is added or modified, initialize Terraform:

```bash
terraform init
```

Terraform configures the backend and migrates the state if necessary.

---

# Terraform State Commands

Terraform provides several commands to inspect and manipulate the state.

---

# 1. `terraform state list`

Displays every resource currently tracked in the state.

Command:

```bash
terraform state list
```

Example Output:

```text
aws_instance.myec2

aws_iam_user.lb
```

This command does **not** query AWS.

It reads directly from the Terraform state.

---

# 2. `terraform state mv`

Moves or renames a resource inside the Terraform state.

Command:

```bash
terraform state mv aws_instance.webapp aws_instance.myec2
```

Meaning:

Old resource address:

```text
aws_instance.webapp
```

New resource address:

```text
aws_instance.myec2
```

Terraform updates only the **state file**.

The EC2 instance in AWS is **not recreated**.

---

## When is `state mv` Useful?

- Renaming resources.
- Refactoring Terraform code.
- Moving resources into modules.
- Splitting configurations.
- Reorganizing projects.

---

# 3. `terraform state pull`

Downloads and displays the current state.

Command:

```bash
terraform state pull
```

Example Output:

```json
{
  "version": 4,
  "resources": [
    ...
  ]
}
```

Useful when:

- Inspecting remote state.
- Troubleshooting.
- Creating backups.
- Understanding resource attributes.

---

# 4. `terraform state rm`

Removes a resource from Terraform state **without deleting the actual infrastructure**.

Command:

```bash
terraform state rm aws_instance.myec2
```

Result:

```
Terraform forgets the EC2 instance.
```

The EC2 instance:

```
Still exists in AWS.
```

It is simply no longer managed by Terraform.

---

## When is `state rm` Useful?

- Importing resources later.
- Handing over management.
- Removing accidentally imported resources.
- Recovering from state issues.

---

# State Command Summary

| Command | Purpose |
|----------|---------|
| `terraform state list` | List all resources in the state file. |
| `terraform state mv` | Rename or move a resource within the state. |
| `terraform state pull` | Download and display the current state. |
| `terraform state rm` | Remove a resource from the state without deleting it from the cloud. |

---

# Important Notes

- **State commands modify only the Terraform state**, not the infrastructure itself (except when future plans act on the changed state).
- Always back up your state before making manual changes.
- Avoid editing the state file manually.
- For team environments, use a remote backend such as Amazon S3.
- When using an S3 backend in production, enable **state locking with DynamoDB** to prevent multiple users from modifying the state simultaneously.

---

# Best Practices

- Store state remotely.
- Enable versioning on the S3 bucket.
- Use DynamoDB state locking with S3.
- Restrict access to the state file using IAM policies.
- Never commit `terraform.tfstate` to Git.
- Never hardcode AWS credentials in Terraform files. Instead, use:
  - AWS CLI profiles
  - Environment variables
  - IAM Roles
  - AWS SSO

---

# Summary

| Component | Purpose |
|-----------|---------|
| State File | Tracks infrastructure managed by Terraform. |
| Local Backend | Stores state on the local machine. |
| S3 Backend | Stores state remotely for collaboration. |
| `terraform state list` | Lists tracked resources. |
| `terraform state mv` | Renames or moves resource addresses in the state. |
| `terraform state pull` | Displays the current state. |
| `terraform state rm` | Removes a resource from Terraform state without deleting it from the cloud. |

---

# Key Takeaways

- Terraform state is the **source of truth** for managed infrastructure.
- The state file maps Terraform configuration to real-world cloud resources.
- Remote backends such as Amazon S3 enable secure team collaboration.
- The `terraform state` commands allow you to inspect and manage state without directly modifying infrastructure.
- Use state commands carefully, as incorrect changes can cause Terraform to lose track of existing resources.
