# Terraform Settings

Terraform **Settings** allow you to define the Terraform version and provider versions that your configuration requires.

This helps ensure your infrastructure code runs consistently across different environments and prevents unexpected failures caused by incompatible Terraform or provider versions.

---

# Why Use Terraform Settings?

Without version constraints:

- Terraform configurations may not work with newer or older Terraform releases.
- Providers (such as AWS) frequently introduce new features, deprecate existing ones, or change behaviour.
- Different team members may use different versions, leading to inconsistent deployments.

Using Terraform settings ensures everyone uses compatible versions.

---

# Terraform Settings Block

Terraform settings are defined inside the `terraform` block.

```hcl
terraform {
  required_version = "1.9.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
```

---

# Base Code

Without any version constraints:

```hcl
resource "aws_security_group" "sg_01" {
  name = "app_firewall"
}
```

---

# Final Code

After adding Terraform settings:

```hcl
terraform {
  required_version = "1.9.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

resource "aws_security_group" "sg_01" {
  name = "app_firewall"
}
```

---

# required_version

The `required_version` argument specifies which version of Terraform is allowed to execute the configuration.

Example:

```hcl
terraform {
  required_version = "1.9.1"
}
```

If someone attempts to run the configuration using another Terraform version, Terraform will display an error.

---

# required_providers

The `required_providers` block specifies:

- Which provider Terraform should use
- Where to download it from
- Which provider version is required

Example:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
```

---

# Provider Source

The `source` tells Terraform where to download the provider.

Example:

```hcl
source = "hashicorp/aws"
```

This means:

- Namespace: `hashicorp`
- Provider: `aws`

Terraform automatically downloads this provider during:

```bash
terraform init
```

---

# Version Constraints

Terraform supports several ways to specify version requirements.

| Constraint | Meaning | Example |
|------------|---------|---------|
| `=` | Exactly this version | `= 5.54.1` |
| `!=` | Any version except this one | `!= 5.54.1` |
| `>` | Greater than | `> 5.54.1` |
| `>=` | Greater than or equal to | `>= 5.54.1` |
| `<` | Less than | `< 6.0.0` |
| `<=` | Less than or equal to | `<= 5.60.0` |
| `~>` | Compatible version constraint | `~> 5.54` |

---

# Version Constraint Examples

## Exact Version

```hcl
version = "= 5.54.1"
```

Only version **5.54.1** is accepted.

---

## Greater Than

```hcl
version = "> 5.54.1"
```

Accepts:

- 5.55
- 5.60
- 6.0

---

## Greater Than or Equal To

```hcl
version = ">= 5.54.1"
```

Accepts:

- 5.54.1
- 5.55
- 5.60
- 6.0

---

## Less Than

```hcl
version = "< 6.0.0"
```

Accepts any version below **6.0.0**.

---

## Less Than or Equal To

```hcl
version = "<= 5.60.0"
```

Accepts:

- 5.60.0
- 5.59.0
- 5.54.1

---

## Not Equal To

```hcl
version = "!= 5.54.1"
```

Accepts every version except **5.54.1**.

---

## Compatible Version (`~>`)

The **pessimistic constraint** (`~>`) allows patch updates while preventing breaking changes.

Example:

```hcl
version = "~> 5.54"
```

Accepts:

- 5.54.0
- 5.54.5
- 5.55.0
- 5.99.0

Does **not** accept:

- 6.0.0

Another example:

```hcl
version = "~> 5.54.1"
```

Accepts:

- 5.54.2
- 5.54.8

Does **not** accept:

- 5.55.0
- 6.0.0

---

# Best Practices

- Always specify a `required_version`.
- Always specify provider versions to ensure consistent deployments.
- Use version constraints to avoid unexpected breaking changes.
- Commit the generated `.terraform.lock.hcl` file to version control so your team uses the same provider versions.
- Run `terraform init` after changing provider versions.

---

# Common Commands

Initialize Terraform and download the required providers:

```bash
terraform init
```

Check the Terraform version:

```bash
terraform version
```

Upgrade providers to newer allowed versions:

```bash
terraform init -upgrade
```

---

# Documentation

Terraform Settings

https://developer.hashicorp.com/terraform/language/settings

AWS Provider Documentation

https://registry.terraform.io/providers/hashicorp/aws/latest
