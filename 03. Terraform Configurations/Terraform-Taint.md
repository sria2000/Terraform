# Terraform Replace (Replacement for Terraform Taint)

## What is Terraform Taint?

In older versions of Terraform, the `terraform taint` command was used to mark a resource as **tainted**.

A tainted resource would be **destroyed and recreated** during the next `terraform apply`, even if there were **no configuration changes**.

> **Note:** `terraform taint` has been **deprecated**. Modern versions of Terraform recommend using the **`-replace`** option with `terraform apply`.

---

## Why Replace a Resource?

Sometimes infrastructure resources are modified **outside of Terraform**.

Examples:

- Manual configuration changes on a server
- Changes made through the AWS Console
- Resource has become corrupted
- Server requires a fresh rebuild
- Resource drift from the Terraform configuration

In these situations, you have two options:

- Import the manual changes back into Terraform (if you want to keep them)
- Destroy and recreate the resource using Terraform

Terraform provides the **`-replace`** option to force the recreation of a resource.

---

## Documentation

https://developer.hashicorp.com/terraform/cli/commands/apply

---

# Syntax

```bash
terraform apply -replace="<resource_address>"
```

Example:

```bash
terraform apply -replace="aws_instance.myec2"
```

---

# Example 1 - Replace an EC2 Instance

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
}
```

Force Terraform to recreate the EC2 instance:

```bash
terraform apply -replace="aws_instance.myec2"
```

Terraform will:

1. Destroy the existing EC2 instance.
2. Create a new EC2 instance.
3. Update the Terraform state.

---

# Example 2 - Replace a Local File

Terraform configuration:

```hcl
resource "local_file" "foo" {
  content  = "Hello from Sri!"
  filename = "${path.module}/Sri.txt"
}
```

Run:

```bash
terraform apply -replace="local_file.foo"
```

### Sample Output

```text
Plan: 2 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.

Enter a value: yes

local_file.foo: Destroying...
local_file.foo: Destruction complete after 0s

local_file.json_example: Creating...
local_file.json_example: Creation complete after 0s

local_file.foo: Creating...
local_file.foo: Creation complete after 0s

Apply complete! Resources: 2 added, 0 changed, 1 destroyed.
```

Terraform destroys the existing resource and creates a brand-new one.

---

# Old vs New Approach

| Older Terraform | Modern Terraform |
|-----------------|------------------|
| `terraform taint aws_instance.myec2` | `terraform apply -replace="aws_instance.myec2"` |
| Marked a resource as tainted | Replaces the resource immediately during `apply` |
| Required two commands (`taint` then `apply`) | Requires only one command |
| Deprecated | Recommended approach |

---

# Benefits of `-replace`

- Forces recreation of a resource.
- Useful when infrastructure has drifted from Terraform state.
- Rebuilds corrupted or manually modified resources.
- Simpler than the old `terraform taint` workflow.
- No need to manually taint resources before applying.

---

# Key Points

- `terraform taint` is **deprecated**.
- Use `terraform apply -replace="<resource_address>"` instead.
- The `-replace` option destroys and recreates the specified resource.
- Useful when manual changes have been made outside Terraform or when a resource needs a clean rebuild.
- Only the specified resource is replaced; the rest of the infrastructure remains unchanged.
