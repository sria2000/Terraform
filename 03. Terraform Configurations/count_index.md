# Terraform Count Index Argument

## Documentation Referred

Terraform Language Documentation:

https://developer.hashicorp.com/terraform/language/meta-arguments/count

---

# Overview

The **`count.index`** argument provides the index number of each resource created using the **`count`** meta-argument.

It is commonly used to:

- Generate unique resource names.
- Create unique tags.
- Avoid duplicate resource names.
- Retrieve values from a list variable.

The index always starts from **0**.

---

# Syntax

```hcl
count.index
```

When `count = 5`, Terraform generates the following index values:

| Resource | count.index |
|----------|------------:|
| First | 0 |
| Second | 1 |
| Third | 2 |
| Fourth | 3 |
| Fifth | 4 |

---

# Example 1 - EC2 Instance with Unique Tags

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"

  count = 30

  tags = {
    Name = "Development-Server-${count.index}"
  }
}
```

---

# Explanation

Terraform creates **30 EC2 instances**.

Each instance receives a unique tag based on its index.

| Instance | Tag Name |
|----------|----------|
| myec2[0] | Development-Server-0 |
| myec2[1] | Development-Server-1 |
| myec2[2] | Development-Server-2 |
| ... | ... |
| myec2[29] | Development-Server-29 |

---

# Visual Representation

```text
count = 30

            │
            ▼

count.index

0
1
2
3
...
29

            │
            ▼

Development-Server-0
Development-Server-1
Development-Server-2
...
Development-Server-29
```

---

# Example 2 - IAM Users

Without `count.index`, the following configuration fails because all users have the same name.

```hcl
resource "aws_iam_user" "lb" {
  name  = "sriram"
  count = 3
}
```

Terraform attempts to create:

```text
sriram
sriram
sriram
```

AWS returns a duplicate name error.

---

## Correct Solution Using count.index

```hcl
resource "aws_iam_user" "lb" {
  name  = "sriram-${count.index}"
  count = 3
}
```

Terraform creates:

```text
sriram-0
sriram-1
sriram-2
```

---

# Output

| Resource | Username |
|----------|----------|
| lb[0] | sriram-0 |
| lb[1] | sriram-1 |
| lb[2] | sriram-2 |

---

# Example 3 - Better Approach Using Variables

Instead of hardcoding names, store them in a list variable.

## Variable Definition

```hcl
variable "users" {
  type = list

  default = [
    "Sri",
    "Ram",
    "Krish"
  ]
}
```

## Resource Configuration

```hcl
resource "aws_iam_user" "lb" {
  name  = var.users[count.index]
  count = 3
}
```

---

# How It Works

Terraform evaluates the list using the current index.

| count.index | Variable Value | User Created |
|-------------|----------------|--------------|
| 0 | Sri | Sri |
| 1 | Ram | Ram |
| 2 | Krish | Krish |

---

# Visual Representation

```text
users

Index     Value
-----     -----
0  -----> Sri
1  -----> Ram
2  -----> Krish

            │
            ▼

count.index

            │
            ▼

Creates IAM Users

Sri
Ram
Krish
```

---

# Advantages of Using Variables

- Easier to maintain.
- No hardcoded usernames.
- Easy to add or remove users.
- Improves code readability.
- Supports reusable Terraform configurations.

---

# Important Notes

- `count.index` always starts at **0**.
- `count.index` is available only when using the `count` meta-argument.
- It can be used in:
  - Resource names
  - Tags
  - Variables
  - Outputs
  - File names
  - Any Terraform expression

---

# Best Practices

✅ Use `count.index` when:

- Creating multiple identical resources with unique names.
- Generating unique tags.
- Reading values from a list variable.

Avoid using `count.index` when resources require independent lifecycle management. In those cases, the **`for_each`** meta-argument is often a better choice.

---

# Terraform Commands

## Initialize

```bash
terraform init
```

## Validate

```bash
terraform validate
```

## Create Execution Plan

```bash
terraform plan
```

## Apply Configuration

```bash
terraform apply
```

## Destroy Resources

```bash
terraform destroy
```

---

# Summary

This document demonstrated:

- What **`count.index`** is.
- Creating unique EC2 instance tags using `count.index`.
- Creating unique IAM usernames.
- Accessing list elements with `count.index`.
- Using variables to create cleaner and more maintainable Terraform configurations.
- Best practices for working with the `count` meta-argument.
