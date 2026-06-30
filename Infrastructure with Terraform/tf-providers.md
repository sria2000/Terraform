# Providers in Terraform

Providers are plugins that allow Terraform to interact with cloud platforms, SaaS providers, and other APIs.

---

# Types of Providers

## a) Official Providers

- Officially maintained by **HashiCorp**.
- Recommended for **Production (PRD)** environments.
- The provider source contains **`hashicorp`**.

### Documentation

Terraform Registry:

https://registry.terraform.io

### Example: Azure Provider

```hcl
provider "azurerm" {
  features {}
}
```

Initialize the provider:

```bash
terraform init
```

### Example: AWS Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

---

## b) Partner Providers

- Maintained by HashiCorp technology partners.
- Common examples include:
  - Alibaba Cloud
  - MongoDB
  - DigitalOcean

### DigitalOcean Provider Documentation

https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

### Example

```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}
```

Initialize the provider:

```bash
terraform init
```

> **Best Practice:** Store the API token in a Terraform variable or environment variable instead of hardcoding it.

---

## c) Community Providers

- Developed and maintained by individual contributors or the open-source community.
- Often used for niche platforms and custom integrations.
- Evaluate documentation, maintenance activity, and community support before using them in production.

---

# Terraform Command

## Initialize Terraform

```bash
terraform init
```

### What `terraform init` Does

- Downloads the required provider plugins.
- Creates the `.terraform` directory.
- Installs the correct provider versions.
- Creates or updates the `.terraform.lock.hcl` lock file.
- Initializes the backend (if configured).
- Prepares the working directory for:
  - `terraform plan`
  - `terraform apply`
  - `terraform destroy`

---

# Typical Workflow

1. Create your Terraform configuration.

2. Initialize Terraform.

```bash
terraform init
```

3. Review the execution plan.

```bash
terraform plan
```

4. Create the infrastructure.

```bash
terraform apply
```

5. Destroy the infrastructure (if required).

```bash
terraform destroy
```

---

# Best Practices

- Use **Official (HashiCorp)** providers whenever possible for production workloads.
- Specify provider versions using the `required_providers` block.
- Never hardcode credentials or API tokens in Terraform files.
- Store secrets using:
  - Environment variables
  - Terraform variables (`*.tfvars`)
  - Cloud secret managers (AWS Secrets Manager, Azure Key Vault, HashiCorp Vault, etc.)
- Commit the `.terraform.lock.hcl` file to version control to ensure consistent provider versions across your team.
