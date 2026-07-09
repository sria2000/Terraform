# Terraform `for_each` Meta-Argument

The `for_each` meta-argument allows Terraform to create and manage **multiple similar resources** without writing separate resource blocks for each one.

Instead of duplicating the same resource definition multiple times, Terraform iterates over a **set** or **map**, creating one resource instance for each element.

`for_each` is commonly used when each resource needs a **stable, unique identity**.

---

# Why Use `for_each`?

Suppose you need to create four IAM users.

Without `for_each`, you would have to write:

```hcl
resource "aws_iam_user" "user1" {
  name = "alice"
}

resource "aws_iam_user" "user2" {
  name = "bob"
}

resource "aws_iam_user" "user3" {
  name = "john"
}

resource "aws_iam_user" "user4" {
  name = "james"
}
```

This results in repetitive code.

Using `for_each`, a single resource block creates all users.

---

# `count` vs `for_each`

Terraform provides two meta-arguments for creating multiple resources:

- `count`
- `for_each`

Both create multiple instances, but they work differently.

| Feature | `count` | `for_each` |
|---------|---------|------------|
| Input Type | Number | Set or Map |
| Resource Identity | Index (`0`, `1`, `2`...) | Key or Set Member |
| Stable When Items Change | No | Yes |
| Best For | Identical resources | Named or unique resources |

---

# Important Keywords

When using `for_each`, Terraform provides two special variables.

## `each.key`

Represents:

- The map key
- Or the set member (for sets)

Example:

```hcl
each.key
```

---

## `each.value`

Represents:

- The value associated with the current map key.
- For sets, `each.value` is the same as `each.key`.

Example:

```hcl
each.value
```

---

# Example 1 – `for_each` with a Set

A set contains unique values.

## Variable

```hcl
variable "user_names" {

  type = set(string)

  default = [
    "alice",
    "bob",
    "john",
    "james"
  ]

}
```

---

## Resource

```hcl
resource "aws_iam_user" "this" {

  for_each = var.user_names

  name = each.value

}
```

---

# What Terraform Creates

Terraform creates four IAM users.

```text
aws_iam_user.this["alice"]

aws_iam_user.this["bob"]

aws_iam_user.this["john"]

aws_iam_user.this["james"]
```

Notice that Terraform uses the **set members** as resource identifiers instead of numeric indexes.

---

# How `each.value` Works

Iteration:

| Set Value | `each.value` |
|-----------|--------------|
| alice | alice |
| bob | bob |
| john | john |
| james | james |

Terraform executes:

```hcl
name = each.value
```

Result:

```text
alice

bob

john

james
```

---

# Example 2 – `for_each` with a Map

Maps contain key-value pairs.

## Variable

```hcl
variable "my-map" {

  default = {

    key  = "value"

    key1 = "value1"

  }

}
```

---

## Resource

```hcl
resource "aws_instance" "web" {

  for_each = var.my-map

  ami = each.value

  instance_type = "t3.micro"

  tags = {

    Name = each.key

  }

}
```

---

# How the Map Is Processed

Terraform reads:

| Map Key | Map Value |
|---------|-----------|
| key | value |
| key1 | value1 |

During each iteration:

| `each.key` | `each.value` |
|-------------|--------------|
| key | value |
| key1 | value1 |

Terraform creates:

```text
aws_instance.web["key"]

aws_instance.web["key1"]
```

with:

```text
AMI = value

Tag Name = key
```

and

```text
AMI = value1

Tag Name = key1
```

---

# Resource Addresses

Unlike `count`, resources created with `for_each` are identified by keys.

Example:

```text
aws_iam_user.this["alice"]

aws_iam_user.this["bob"]

aws_instance.web["key"]

aws_instance.web["key1"]
```

---

# Why `for_each` Is Better Than `count`

Suppose you have:

```hcl
toset([
  "alice",
  "bob",
  "john"
])
```

Later you add:

```hcl
"james"
```

Terraform creates only:

```text
aws_iam_user.this["james"]
```

The existing resources remain unchanged.

With `count`, changing the order of items can shift indexes and cause unnecessary updates or replacements.

`for_each` avoids this problem because resources are identified by their keys rather than numeric positions.

---

# When to Use `for_each`

Use `for_each` when:

- Resource names are unique.
- Resources have different configurations.
- You need stable resource identities.
- Managing users, servers, databases, or storage accounts.

Examples:

- IAM users
- EC2 instances
- Security groups
- DNS records
- S3 buckets
- Azure Resource Groups

---

# Best Practices

- Prefer `for_each` over `count` when resources have unique names.
- Use a **set** when you only need unique values.
- Use a **map** when each resource has associated configuration data.
- Avoid converting between `count` and `for_each` after resources are created, as this changes resource addresses in the Terraform state.

---

# Summary

| Feature | Description |
|---------|-------------|
| `for_each` | Creates one resource for each element in a set or map |
| `each.key` | Map key or set member |
| `each.value` | Map value (or the same as `each.key` for sets) |
| Supported Collections | Set and Map |
| Resource Address | Uses keys instead of numeric indexes |

---

# Key Takeaways

- `for_each` creates multiple resource instances from a **set** or **map**.
- Resources are identified by **keys**, providing stable identities.
- `each.key` returns the current key (or set member).
- `each.value` returns the associated value.
- `for_each` is generally preferred over `count` for managing named resources because it avoids issues caused by changing list indexes.

---

# Documentation

AWS Provider Documentation

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
