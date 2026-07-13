# Terraform Modules – Using a Local Path

## Overview

Terraform modules do not have to be stored in GitHub or the Terraform Registry. During development, it is common to store reusable modules locally within the same project.

A **local path module** allows multiple teams or projects to share reusable Terraform code from a central **modules** directory.

> **Note:** Local module paths typically begin with:
>
> - `./` – Current directory
> - `../` – Parent directory

---

# Project Structure

```
terraform-project/

├── modules/
│   ├── ec2/
│   ├── iam/
│   └── sg/
│
├── teams/
│   ├── A/
│   └── B/
```

In this example:

- The reusable EC2 module is stored under `modules/ec2`
- Team A and Team B consume the same module

---

# Step 1 - Navigate to Team A

```bash
cd teams/A
```

Current directory:

```text
D:\Terraform\TERRAFORMLAB\ec2_module\teams\A
```

---

# Step 2 - Create the Module Reference

Create **module.tf**

```terraform
module "ec2" {
  source = "../../modules/ec2"
}
```

## Understanding the Path

```
../../modules/ec2
```

```
..
```

Moves up one directory.

```
../..
```

Moves up two directories.

```
modules/ec2
```

Points to the reusable EC2 module.

From:

```
teams/A
```

Terraform resolves the path as:

```
teams/A
      │
      ├── ..
      │
      ├── ..
      │
      ▼
modules/ec2
```

---

# Step 3 - Create the EC2 Module

Inside:

```
modules/ec2
```

Create **main.tf**

```terraform
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0d0463f1527996442"
  instance_type = "t2.micro"
}
```

This file contains the reusable infrastructure definition.

---

# Step 4 - Initialize Terraform

From the **teams/A** directory, run:

```bash
terraform init
```

Example output:

```text
Initializing modules...

- ec2 in ..\..\modules\ec2

Initializing provider plugins...

- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v6.54.0...
- Installed hashicorp/aws v6.54.0 (signed by HashiCorp)

Initializing the backend...

Terraform has created a lock file .terraform.lock.hcl

Terraform has been successfully initialized!
```

Notice Terraform displays:

```text
ec2 in ..\..\modules\ec2
```

This confirms Terraform located the module using the relative local path.

---

# Step 5 - Verify the Plan

```bash
terraform plan
```

Terraform should display something similar to:

```text
# module.ec2.aws_instance.myec2 will be created

Plan: 1 to add, 0 to change, 0 to destroy.
```

The prefix:

```
module.ec2
```

indicates that the resource is being created from the local module.

---

# Step 6 - Deploy the Infrastructure

```bash
terraform apply
```

Or automatically approve:

```bash
terraform apply -auto-approve
```

Terraform creates the EC2 instance defined inside the local module.

---

# Step 7 - Destroy the Infrastructure

```bash
terraform destroy
```

Or:

```bash
terraform destroy -auto-approve
```

---

# Visual Flow

```
teams/A
   │
   │
   ▼
module.tf
   │
   │ source = "../../modules/ec2"
   ▼
modules/ec2
   │
   ▼
main.tf
   │
   ▼
AWS Provider
   │
   ▼
EC2 Instance
```

---

# Advantages of Local Modules

- Simple to develop and test.
- No internet or Git repository required.
- Easy to modify during development.
- Ideal for learning Terraform modules.
- Multiple teams can reuse the same module.
- Encourages a standardized project structure.

---

# Relative Path Examples

| Source | Meaning |
|---------|---------|
| `./modules/ec2` | Module inside the current directory |
| `../modules/ec2` | Module in the parent directory |
| `../../modules/ec2` | Module two levels above the current directory |
| `../../../modules/ec2` | Module three levels above the current directory |

---

# Best Practices

- Store all reusable modules inside a dedicated `modules` directory.
- Name modules based on their purpose (for example, `ec2`, `vpc`, `iam`, `sg`).
- Keep modules focused on a single resource or service.
- Replace hard-coded values with input variables.
- Use outputs to expose reusable information.
- Once a module becomes stable, consider moving it to a Git repository or the Terraform Registry for easier sharing and versioning.

---

# Summary

Using a **local path** is the simplest way to reuse Terraform modules within the same project. By referencing modules with relative paths (`./` or `../`), multiple teams can share common infrastructure code without duplication. This approach promotes consistency, simplifies maintenance, and is an excellent starting point before publishing modules to GitHub or the Terraform Registry.
