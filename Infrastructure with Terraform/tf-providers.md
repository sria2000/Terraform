# Providers in Terraform

Providers are plugins that allow Terraform to interact with cloud platforms, SaaS providers, and other APIs.

## Types of Providers

### a) Official Providers

- Officially maintained by **HashiCorp**.
- Recommended for **production (PRD)** environments.
- The provider source contains **`hashicorp`**.

**Example:**

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

### b) Partner Providers

- Maintained by HashiCorp technology partners.
- Examples:
  - Alibaba Cloud
  - MongoDB
  - DigitalOcean

**Example:**

```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
```

---

### c) Community Providers

- Developed and maintained by individual contributors or the open-source community.
- Suitable for niche integrations.
- Review documentation and community support before using them in production.

---

# Terraform Command

## Initialize Terraform

Downloads the required providers and initializes the working directory.

```bash
terraform init
```

### What `terraform init` does

- Downloads the required providers.
- Creates the `.terraform` directory.
- Downloads provider plugins.
- Creates or updates the `.terraform.lock.hcl` lock file.
- Prepares the working directory for `terraform plan` and `terraform apply`.
