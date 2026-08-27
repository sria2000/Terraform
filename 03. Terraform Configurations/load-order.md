# Terraform Load Order and Semantics

## Basics

Terraform automatically loads **all** configuration files with the following extensions in the current working directory:

- `.tf`
- `.tf.json`

It merges all the configurations into a **single configuration** before creating the execution plan.

### Example

Directory contents:

```
ec2.tf
app.tf
user.tf.json
```

Running:

```bash
terraform plan
```

Terraform reads all three files, merges the configuration, and creates a single execution plan.

---

## Running Only a Specific Resource

Terraform does **not** allow running a single `.tf` file directly.

If you want to apply or plan only a specific resource, use the `-target` option.

Example:

```bash
terraform plan -target=local_file.foo
```

or

```bash
terraform apply -target=aws_instance.web
```

> **Note:** `-target` operates on resources or modules, **not** on individual `.tf` files.

---

# Example Configuration

## file-one.tf

```hcl
resource "local_file" "foo" {
  content  = "Hello from KPLABS!"
  filename = "${path.module}/kplabs.txt"
}
```

---

## file-two.tf

```hcl
resource "local_file" "foo2" {
  content  = "Hello!"
  filename = "${path.module}/two.txt"
}
```

---

## file-three.tf.json

```json
{
  "resource": {
    "local_file": {
      "json_example": {
        "filename": "${path.module}/hello_from_json.txt",
        "content": "This file was created using Terraform JSON syntax!"
      }
    }
  }
}
```

Running:

```bash
terraform plan
```

Terraform loads all three files and creates a single execution plan.

---

# Duplicate Resource Error

If two files define the **same resource type and resource name**, Terraform throws an error.

Example:

### file-one.tf

```hcl
resource "local_file" "foo" {
  content  = "Hello from KPLABS!"
  filename = "${path.module}/kplabs.txt"
}
```

### file-two.tf

```hcl
resource "local_file" "foo" {
  content  = "Another file"
  filename = "${path.module}/another.txt"
}
```

Running:

```bash
terraform plan
```

Produces an error similar to:

```text
Error: Duplicate resource "local_file" configuration
```

This happens because both files define the same resource:

- Resource Type: `local_file`
- Resource Name: `foo`

Resource names must be unique within a module.

---

# Terraform Load Order

Terraform reads configuration files in **alphabetical order**.

Example:

```
01-provider.tf
02-network.tf
03-security.tf
04-ec2.tf
variables.tf
outputs.tf
```

Although Terraform loads files alphabetically, the execution order is determined by **resource dependencies**, **not** by filename.

---

# Subdirectories

Terraform only reads configuration files in the **current working directory**.

Example:

```
terraform-project/
│
├── main.tf
├── variables.tf
└── modules/
    └── network/
        └── main.tf
```

Terraform **does not automatically read** files inside `modules/` or any other subdirectory.

Subdirectories are only loaded when referenced explicitly, for example:

```hcl
module "network" {
  source = "./modules/network"
}
```

---

# Best Practice

Splitting Terraform configuration into multiple files such as:

```
provider.tf
variables.tf
network.tf
compute.tf
security.tf
outputs.tf
```

is done **for human readability and maintainability**.

Terraform treats them as **one combined configuration**, regardless of how they are split.

---

# Key Notes

- Terraform automatically loads all `.tf` and `.tf.json` files in the current directory.
- All configuration files are merged into a single configuration.
- Terraform reads files in alphabetical order.
- Resource execution order depends on dependencies, not filenames.
- Terraform does **not** automatically read subdirectories.
- Resource names must be unique within a module.
- Use `-target` to plan or apply specific resources—not individual `.tf` files.
```
