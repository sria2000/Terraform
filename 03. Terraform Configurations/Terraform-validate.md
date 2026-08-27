# Terraform Validate

## What is `terraform validate`?

`terraform validate` checks whether your Terraform configuration is **syntactically valid** and internally consistent.

It verifies that:

- ✅ Terraform configuration syntax is correct.
- ✅ Resource blocks contain only supported arguments.
- ✅ Required arguments are present.
- ✅ Variable references are valid.
- ✅ Provider and resource configurations are structurally correct.

> **Note:** `terraform validate` **does not** create or modify any infrastructure. It only validates the configuration.

---

## Documentation

https://developer.hashicorp.com/terraform/cli/commands/validate

---

# Example 1 - Invalid AWS Resource

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = var.instancetype

  sky = "blue"
}
```

### Problem

The `aws_instance` resource does **not** support an argument named `sky`.

Running:

```bash
terraform validate
```

Terraform reports an **Unsupported argument** error.

---

# Example 2 - Invalid Local File Resource

```hcl
resource "local_file" "foo" {
  content  = "Hello from Sri!"
  filename = "${path.module}/Sri.txt"

  hi = there
}
```

### Validation Output

```text
PS D:\Terraform\TERRAFORMLAB> terraform validate

╷
│ Error: Unsupported argument
│
│   on data-sources-02.tf line 4, in resource "local_file" "foo":
│    4:   hi = there
│
│ An argument named "hi" is not expected here. Did you mean "id"?
╵

PS D:\Terraform\TERRAFORMLAB>
```

### Why?

The `local_file` resource does not have a property called `hi`, so Terraform flags it as an **Unsupported argument**.

---

# Command

```bash
terraform validate
```

---

# When to Use `terraform validate`

Run validation:

- Before running `terraform plan`
- Before running `terraform apply`
- Before committing code to Git
- As part of a CI/CD pipeline
- After making changes to Terraform configuration

---

# Difference Between `terraform fmt` and `terraform validate`

| Command | Purpose |
|---------|----------|
| `terraform fmt` | Formats Terraform files according to Terraform style guidelines |
| `terraform validate` | Checks whether the Terraform configuration is syntactically valid |

---

# Workflow

```text
Write Terraform Code
        │
        ▼
terraform fmt
        │
        ▼
terraform validate
        │
        ▼
terraform plan
        │
        ▼
terraform apply
```

---

# Key Points

- Checks Terraform configuration for syntax and structural errors.
- Detects unsupported arguments and missing required arguments.
- Does **not** contact the cloud provider or create resources.
- Safe to run anytime during development.
- A good practice is to run `terraform fmt` before `terraform validate`.
