# Create an EC2 Instance Using a Terraform Module from GitHub

## Overview

This guide demonstrates how to create an AWS EC2 instance by referencing a Terraform module stored in a GitHub repository.

Instead of copying Terraform code into every project, Terraform downloads the module directly from GitHub during `terraform init`.

---

# Prerequisites

- Terraform installed
- AWS account
- AWS credentials configured
- GitHub repository containing the Terraform module

---

# Step 1 - Create the Terraform Module in GitHub

Create a repository (or folder) containing the module source code.

Example location:

```
https://github.com/sria2000/Terraform.git//5. Terraform Modules/source code
```

Create a file named **main.tf** with the following contents.

```terraform
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0d0463f1527996442"
  instance_type = "t2.micro"
}
```

This file becomes the reusable Terraform module.

---

# Step 2 - Create modules.tf

In your Terraform project, create a file named **modules.tf**.

```terraform
module "ec2" {

  source = "git::https://github.com/sria2000/Terraform.git//5. Terraform Modules/source code"

}
```

## Understanding the Source

```
git::
```

Tells Terraform to download the module from a Git repository.

```
https://github.com/sria2000/Terraform.git
```

The GitHub repository.

```
//
```

Separates the repository from the folder inside the repository.

```
5. Terraform Modules/source code
```

The folder containing the Terraform module.

---

# Step 3 - Initialize Terraform

Run:

```bash
terraform init
```

Example output:

```text
Initializing modules...

Downloading git::https://github.com/sria2000/Terraform.git for ec2...

- ec2 in .terraform\modules\ec2\5. Terraform Modules\source code

Initializing provider plugins...

- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v6.54.0...
- Installed hashicorp/aws v6.54.0 (signed by HashiCorp)

Initializing the backend...

Terraform has created a lock file .terraform.lock.hcl

Terraform has been successfully initialized!
```

### What Happens During `terraform init`?

Terraform performs several tasks:

- Downloads the module from GitHub.
- Stores it under the local `.terraform/modules` directory.
- Downloads the required AWS provider.
- Creates the `.terraform.lock.hcl` file.
- Initializes the working directory.

---

# Step 4 - Verify the Execution Plan

Run:

```bash
terraform plan
```

Terraform should display something similar to:

```text
Terraform will perform the following actions:

# module.ec2.aws_instance.myec2 will be created

+ resource "aws_instance" "myec2" {

    ami           = "ami-0d0463f1527996442"

    instance_type = "t2.micro"

    region        = "eu-west-1"

    ...

}

Plan: 1 to add, 0 to change, 0 to destroy.
```

Notice that Terraform prefixes the resource with:

```
module.ec2
```

This indicates the EC2 instance is being created from the **ec2 module**, not directly from the root configuration.

---

# Step 5 - Create the EC2 Instance

Run:

```bash
terraform apply
```

Terraform prompts for confirmation.

```
Enter a value:
```

Type:

```text
yes
```

Terraform creates the EC2 instance defined inside the GitHub module.

---

# Step 6 - Verify the EC2 Instance

You can verify the instance by:

- AWS Console → EC2 → Instances
- Terraform state

```bash
terraform state list
```

Example:

```text
module.ec2.aws_instance.myec2
```

---

# Step 7 - Destroy the EC2 Instance

To remove the infrastructure:

```bash
terraform destroy
```

Or automatically approve:

```bash
terraform destroy -auto-approve
```

---

# Directory Structure

```
Project

│
├── modules.tf
├── terraform.tfstate
├── .terraform/
│
└── .terraform.lock.hcl
```

After initialization, Terraform downloads the GitHub module into:

```
.terraform/
└── modules/
      └── ec2/
```

---

# How It Works

```
Terraform Project
       │
       │
       ▼
modules.tf
       │
       │
       ▼
GitHub Repository
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

# Benefits of Using GitHub Modules

- Centralized infrastructure code
- Reusable across multiple projects
- Easy maintenance
- Version controlled
- Supports collaboration
- Eliminates duplicate Terraform code
- Encourages standardized infrastructure

---

# Best Practices

- Store reusable infrastructure in dedicated repositories.
- Keep modules focused on a single purpose.
- Use variables instead of hard-coded values.
- Define outputs for reusable information.
- Pin module versions for production deployments.
- Review changes before updating shared modules.
- Use Git tags or releases to version modules.

---

# Summary

Terraform modules allow you to reuse infrastructure code across multiple projects. By storing modules in GitHub, teams can maintain a single source of truth while Terraform automatically downloads and uses the module during `terraform init`. This approach improves consistency, simplifies maintenance, and follows infrastructure-as-code best practices.
