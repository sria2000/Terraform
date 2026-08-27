# Terraform Module Concepts

## Index

1. Root Module
2. Child Module
3. Standard Module Structure
4. Multiple Provider Configurations in Modules
5. Publishing Modules to the Terraform Registry

---

# 1. Root Module

The **Root Module** is the main Terraform configuration that resides in your working directory.

It serves as the **entry point** for your infrastructure deployment and is responsible for:

- Configuring providers
- Calling child modules
- Managing variables
- Creating top-level resources

Example:

```terraform
module "ec2" {
  source = "../../modules/ec2"
}
```

The root module orchestrates the deployment by invoking one or more child modules.

---

# 2. Child Module

A **Child Module** is any module that is called by another module (typically the root module).

Example:

### Root Module

```terraform
module "ec2" {
  source = "../../modules/ec2"
}
```

### Child Module (`modules/ec2/main.tf`)

```terraform
resource "aws_instance" "myec2" {

  ami           = var.ami

  instance_type = var.instance_type

}
```

The child module contains the reusable infrastructure code.

It can receive:

- Variables
- Provider configurations
- Outputs from other modules

---

# Root Module vs Child Module

| Root Module | Child Module |
|-------------|--------------|
| Entry point of Terraform | Called by another module |
| Configures providers | Contains reusable infrastructure |
| Passes variables | Receives variables |
| Calls modules | Creates resources |
| Runs `terraform apply` | Cannot be executed independently |

---

# 3. Standard Module Structure

HashiCorp recommends a standard file and directory layout for reusable modules.

Rather than creating one large module, build small focused modules such as:

- EC2
- VPC
- S3
- IAM
- ELB
- Security Groups

---

## Minimal Recommended Structure

```
minimal-module/

├── README.md
├── main.tf
├── variables.tf
└── outputs.tf
```

### Purpose of Each File

| File | Purpose |
|------|---------|
| README.md | Documentation and usage examples |
| main.tf | Resources |
| variables.tf | Input variables |
| outputs.tf | Outputs exposed to callers |

---

## Typical Production Module Structure

```
terraform-aws-ec2/

├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── providers.tf
├── locals.tf
├── data.tf
├── examples/
├── tests/
└── LICENSE
```

This layout improves maintainability and readability.

---

# 4. Multiple Provider Configurations in Modules

Sometimes a module needs to deploy resources across multiple AWS regions or accounts.

For example:

- Development resources in **US East**
- Production resources in **Mumbai**
- Disaster Recovery in **Europe**

Terraform supports this using **provider aliases**.

---

## Child Module

**modules/network/sg.tf**

```terraform
terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

      configuration_aliases = [aws.prod]

    }

  }

}

resource "aws_security_group" "dev" {

  name = "dev-sg"

}

resource "aws_security_group" "prod" {

  name     = "prod-sg"

  provider = aws.prod

}
```

Notice:

```terraform
provider = aws.prod
```

This resource uses an alternate provider configuration.

---

## Root Module

```terraform
provider "aws" {

  region = "us-east-1"

}

provider "aws" {

  alias  = "mumbai"

  region = "ap-south-1"

}

module "sg" {

  source = "./modules/network"

  providers = {

    aws.prod = aws.mumbai

  }

}
```

Terraform now creates:

- Development Security Group → US East
- Production Security Group → Mumbai

---

# Provider Mapping

```
Root Module

Provider aws
      │
      ▼
US East

Provider aws.mumbai
      │
      ▼
Mumbai

          │
          ▼

Module "sg"

aws.prod
      │
      ▼

Security Group (Production)
```

---

# Why Use Provider Aliases?

Provider aliases are useful when:

- Deploying to multiple AWS regions.
- Deploying across multiple AWS accounts.
- Creating Disaster Recovery environments.
- Managing hybrid or multi-cloud deployments.
- Separating development, staging, and production environments.

---

## Important Note

The `providers` argument inside a module block works similarly to the `provider` argument used within a resource, but instead of accepting a single provider configuration, it accepts a **map of provider configurations**.

Provider configurations that use the `alias` argument are **not inherited automatically** by child modules. They **must always be passed explicitly** using the `providers` map.

Example:

```terraform
module "network" {

  source = "./modules/network"

  providers = {

    aws.prod = aws.mumbai

  }

}
```

---

# 5. Publishing Modules to the Terraform Registry

Terraform modules can be published to the public Terraform Registry, allowing them to be reused by anyone.

Terraform Registry:

https://registry.terraform.io/

---

## Requirements

### 1. GitHub Repository

The module must be hosted in GitHub.

---

### 2. Repository Naming Convention

Repositories must follow Terraform's three-part naming format.

```
terraform-<PROVIDER>-<NAME>
```

Example:

```
terraform-aws-vpc

terraform-aws-ec2

terraform-aws-s3
```

---

### 3. Repository Description

Provide a clear GitHub repository description explaining the module's purpose.

---

### 4. Standard Module Structure

At a minimum, include:

```
README.md
main.tf
variables.tf
outputs.tf
```

A complete module may also include:

```
versions.tf
providers.tf
locals.tf
examples/
tests/
LICENSE
```

---

### 5. Semantic Version Tags

Terraform Registry requires Git tags.

Example:

```
v1.0.0

v1.0.1

v1.1.0

v2.0.0
```

Semantic versioning follows the format:

```
MAJOR.MINOR.PATCH
```

Examples:

- `v1.0.0` – Initial release
- `v1.1.0` – New features
- `v1.1.2` – Bug fixes
- `v2.0.0` – Breaking changes

---

# Best Practices

- Keep modules small and focused.
- One module should solve one problem.
- Avoid hardcoded values.
- Use variables for customization.
- Expose only necessary outputs.
- Follow the standard module structure.
- Pin provider versions.
- Document every input and output.
- Version your modules using Git tags.
- Test modules before publishing.

---

# Summary

Terraform modules provide a structured way to organize reusable infrastructure code. The **root module** acts as the entry point, while **child modules** encapsulate reusable resources. Following HashiCorp's recommended module structure, using provider aliases for multi-region deployments, and publishing versioned modules to the Terraform Registry enables scalable, maintainable, and production-ready Infrastructure as Code.
