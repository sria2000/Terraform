# Terraform Modules

## Overview

As Terraform deployments grow, managing infrastructure using standalone resource blocks becomes increasingly difficult. **Terraform Modules** help solve this problem by allowing infrastructure code to be reused across multiple projects.

Modules follow the **DRY (Don't Repeat Yourself)** principle by centralizing common infrastructure definitions into reusable templates.

---

# Why Modules?

### Example Scenario

Imagine an organization with **10 different development teams**, each creating their own EC2 instances.

Initially this works, but over time several problems begin to appear.

## Challenges

1. Repeated Terraform code across multiple projects
2. AWS provider changes require modifications in every project
3. Lack of standardization
4. Difficult to manage at scale
5. Developers spend time recreating the same infrastructure

---

# Better Approach – Terraform Modules

Instead of every team writing their own Terraform code:

- Create a **standard infrastructure template** centrally.
- Store reusable code inside modules.
- Multiple projects can reuse the same module.
- Updates happen in one place.

Example module location:

```
terraform-modules/
    ec2-instance/
```

Modules centralize resource configuration and make infrastructure reusable across multiple teams and projects.

---

# Example – Using a Public EC2 Module

Terraform Registry contains thousands of community-maintained modules.

Documentation:

https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest

Example:

```terraform
module "ec2-instance" {
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "6.1.4"

  subnet_id  = "subnet-03f8c90a72ead2e4d"   # Change this value
}
```

> **Note:** Replace the subnet ID with one from your AWS environment.

---

## Commands

```bash
terraform init
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

# Choosing the Right Terraform Module

Terraform Registry:

https://registry.terraform.io/modules/

When selecting a module, consider the following:

### 1. Total Downloads

Choose modules with a high number of downloads.

### 2. GitHub Repository

Review:

- Open issues
- Pull requests
- Contributor activity

### 3. Number of Contributors

Avoid modules maintained by a single contributor.

### 4. Documentation

Well-written documentation usually indicates a mature project.

### 5. Version History

Check how frequently new releases are published.

### 6. Code Quality

Review:

- Folder structure
- Variables
- Outputs
- Readability

### 7. Community Feedback

Read GitHub issues and community discussions.

### 8. HashiCorp Verified Modules

Whenever possible, prefer modules maintained or verified by HashiCorp.

### 9. Security

Avoid abandoned or poorly maintained third-party modules.

Since Terraform executes module code, using untrusted modules can introduce security risks.

### 10. Organizational Standards

Many organizations maintain their own internal modules to enforce:

- Naming standards
- Security policies
- Tagging
- Networking standards

---

# Creating Your Own Module Structure

A common folder layout is shown below.

```
terraform-project/

│
├── modules/
│   ├── ec2/
│   ├── iam/
│   └── sg/
│
├── teams/
│   ├── A/
│   └── B/
```

The **modules** folder contains reusable infrastructure.

Each team simply references the required module.

---

# Create Directory Structure

```bash
mkdir -p modules/ec2
mkdir -p modules/sg

mkdir -p teams/A
mkdir -p teams/B
```

---

# EC2 Module

**modules/ec2/main.tf**

```terraform
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0bb84b8ffd87024d8"
  instance_type = "t2.micro"
}
```

---

# Team A Calls the Module

**teams/A/ec2.tf**

```terraform
module "ec2module" {
  source = "../../modules/ec2"
}
```

---

# Team A Provider Configuration

**teams/A/providers.tf**

```terraform
provider "aws" {
  region     = "us-west-2"

  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}
```

---

# Module Source Locations

Terraform modules can be stored in many locations.

| Source | Example |
|---------|----------|
| Local Path | Local folders |
| Git Repository | GitHub, GitLab |
| HTTP URLs | ZIP archives |
| Amazon S3 | Versioned module packages |
| Terraform Registry | Official Registry |

---

# Example 1 – Local Module

```terraform
module "ec2" {
  source = "../modules/ec2"
}
```

---

# Example 2 – Git Repository

```terraform
module "vpc" {
  source = "git::https://example.com/ec2.git"
}
```

---

# Example 3 – HTTP URL

```terraform
module "ec2" {
  source = "https://example.com/aws-module.zip"
}
```

---

# Example 4 – Amazon S3

```terraform
module "vpc" {
  source = "s3::https://s3-us-east-1.amazonaws.com/example-modules/vpc.zip"
}
```

---

# Example – Calling a Module from GitHub

Assume the following repository:

```
github.com/sria2000/sample-ec2-module/

└── folder/
      └── main.tf
```

**folder/main.tf**

```terraform
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0d0463f1527996442"
  instance_type = "t2.micro"
}
```

---

## modules.tf

```terraform
module "ec2" {

  source = "git::https://github.com/sria2000/Terraform.git//5. Terraform Modules/source code"

}
```

---

## Initialize Terraform

```bash
terraform init
```

Example output:

```text
Initializing modules...

Downloading git::https://github.com/sria2000/Terraform.git for ec2...

- ec2 in .terraform\modules\ec2\5. Terraform Modules\source code

Initializing provider plugins...

Terraform has been successfully initialized!
```

Once initialization completes, Terraform downloads the module into the local `.terraform/modules` directory.

---

# Deploy the Infrastructure

```bash
terraform plan

terraform apply
```

---

# Module Versioning

Modules often have multiple published versions.

It is recommended to pin a specific version to ensure consistent deployments.

Example:

```terraform
module "eks" {

  source  = "terraform-aws-modules/eks/aws"

  version = "20.11.1"

}
```

Using version pinning ensures:

- Stable deployments
- Reproducible infrastructure
- Controlled upgrades
- Reduced risk from breaking changes

---

# Best Practices

- Follow the DRY principle.
- Build reusable modules for common infrastructure.
- Keep modules small and focused.
- Use variables instead of hardcoded values.
- Define outputs for reusable information.
- Store modules in version control.
- Pin module versions.
- Review third-party modules before using them.
- Prefer HashiCorp Verified or well-maintained community modules.
- Maintain internal modules for organization-wide standards.

---

# Summary

Terraform Modules are one of the most powerful features of Terraform. They promote code reuse, consistency, and maintainability while reducing duplication across projects. Whether using modules from the Terraform Registry, Git repositories, or creating your own internal modules, adopting modules is considered a Terraform best practice for managing infrastructure at scale.
