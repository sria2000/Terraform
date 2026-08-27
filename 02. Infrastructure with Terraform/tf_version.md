# Terraform Provider Versioning

Terraform allows you to specify version constraints for providers. Version constraints help ensure that your infrastructure uses compatible provider versions and avoids unexpected changes caused by provider upgrades.

> **Best Practice:** In modern Terraform, specify provider versions inside the `required_providers` block rather than using the deprecated `version` argument in the `provider` block.

---

# Common Version Constraints

## Exact Version

Use a specific provider version.

```hcl
version = "2.7"
```

Terraform installs only version **2.7**.

---

## Greater Than or Equal To

```hcl
version = ">= 2.8"
```

Terraform installs version **2.8** or any newer compatible version.

---

## Less Than or Equal To

```hcl
version = "<= 2.8"
```

Terraform installs version **2.8** or any earlier version.

---

## Version Range

```hcl
version = ">=2.10,<=2.30"
```

Terraform installs any provider version between **2.10** and **2.30**, inclusive.

---

# Base Configuration (Legacy Syntax)

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
  version    = ">=2.10,<=2.30"
}

resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"
}
```

> **Note:** The `version` argument inside the `provider` block is **deprecated** and retained only for older Terraform configurations.

---

# Recommended Configuration (Modern Syntax)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.10, <= 2.30"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"
}
```

---

# Common Version Operators

| Constraint | Description |
|------------|-------------|
| `=` or no operator | Install the exact version specified. |
| `!=` | Exclude a specific version. |
| `>` | Install versions greater than the specified version. |
| `>=` | Install the specified version or newer. |
| `<` | Install versions earlier than the specified version. |
| `<=` | Install the specified version or earlier. |
| `~>` | Allow only patch or minor updates, depending on the version specified. |

### Examples of the `~>` Operator

```hcl
version = "~> 5.0"
```

Allows:

- 5.0.x
- 5.1.x
- 5.20.x

But **not**:

- 6.0.0

---

```hcl
version = "~> 5.10.0"
```

Allows:

- 5.10.1
- 5.10.5
- 5.10.20

But **not**:

- 5.11.0

---

# Commands

Initialize Terraform and download the appropriate provider version:

```bash
terraform init
```

View the installed provider version:

```bash
terraform providers
```

Upgrade providers to the latest version that satisfies the version constraint:

```bash
terraform init -upgrade
```

---

## Best Practices

- Use `required_providers` instead of the deprecated `provider.version`.
- Avoid hardcoding AWS credentials in Terraform configuration files.
- Pin provider versions in production to ensure consistent deployments.
- Commit the `.terraform.lock.hcl` file to version control so all team members use the same provider versions.
