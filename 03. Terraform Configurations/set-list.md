# Terraform List and Set Data Types

Terraform supports several collection data types for storing multiple values.

Two of the most commonly used collection types are:

- **List**
- **Set**

Although both can store multiple values, they behave differently.

---

# List Data Type

A **List** is an ordered collection of values.

Characteristics:

- Allows duplicate values.
- Maintains the order of elements.
- Elements can be accessed using an index.
- Indexing starts from **0**.

---

# List Syntax

```hcl
variable "my-list" {

  type = list(string)

  default = [
    "hello",
    "world",
    "hello"
  ]

}
```

Notice that the value `"hello"` appears twice.

Lists allow duplicate values.

---

# Example 1

```hcl
variable "my-list" {

  type = list(string)

  default = [
    "hello",
    "world",
    "hello"
  ]

}

output "mylist" {

  value = var.my-list

}
```

Output:

```text
[
  "hello",
  "world",
  "hello"
]
```

---

# Example 2

```hcl
variable "my-list" {

  type = list(string)

  default = [
    "one",
    "two",
    "three"
  ]

}

output "my-list" {

  value = var.my-list

}
```

Run:

```bash
terraform apply -auto-approve
```

Output:

```text
my-list = tolist([
  "one",
  "two",
  "three",
])
```

---

# Accessing List Elements

Lists support indexing.

Example:

```hcl
output "my-list" {

  value = var.my-list[0]

}
```

Output:

```text
my-list = "one"
```

List indexing:

| Index | Value |
|-------:|-------|
| 0 | one |
| 1 | two |
| 2 | three |

---

# When to Use a List

Use a list when:

- Order is important.
- Duplicate values are allowed.
- You need to access elements by index.

Examples:

- Availability Zones
- Ordered server names
- IP address lists
- Port numbers

---

# Set Data Type

A **Set** is an unordered collection of unique values.

Characteristics:

- Duplicate values are automatically removed.
- Does not maintain element order.
- Does not support indexing.
- Each value must be unique.

---

# Set Syntax

```hcl
variable "my-set" {

  type = set(string)

  default = [
    "alice",
    "bob",
    "john"
  ]

}
```

---

# Duplicate Values

Example:

```hcl
[
  "hello",
  "world",
  "hello"
]
```

Stored as a set:

```text
[
  "hello",
  "world"
]
```

The duplicate `"hello"` is automatically removed.

---

# Example

```hcl
variable "my-set" {

  type = set(string)

  default = [
    "a",
    "b",
    "c",
    "a"
  ]

}

output "my-set" {

  value = var.my-set

}
```

Run:

```bash
terraform apply -auto-approve
```

Output:

```text
my-set = toset([
  "a",
  "b",
  "c",
])
```

Notice that the duplicate value `"a"` appears only once.

---

# Why Sets Have No Index

A set is **unordered**.

Terraform does not guarantee where an element is stored.

For example:

```text
toset([
  "a",
  "b",
  "c"
])
```

Terraform may internally store them in any order.

Because the order is not guaranteed, expressions such as:

```hcl
var.my-set[0]
```

are **not valid**.

---

# List vs Set

| Feature | List | Set |
|---------|------|-----|
| Ordered | Yes | No |
| Allows duplicates | Yes | No |
| Supports indexing | Yes | No |
| Preserves insertion order | Yes | No |
| Unique values only | No | Yes |

---

# Comparison Example

## List

```hcl
[
  "a",
  "b",
  "c",
  "a"
]
```

Result:

```text
[
  "a",
  "b",
  "c",
  "a"
]
```

Duplicates are preserved.

---

## Set

```hcl
[
  "a",
  "b",
  "c",
  "a"
]
```

Result:

```text
[
  "a",
  "b",
  "c"
]
```

Duplicate values are removed.

---

# When to Use Each

## Use a List

- Order matters.
- Duplicate values are allowed.
- You need index-based access.

Examples:

- Ordered server names
- Ordered IP addresses
- Port lists
- Availability Zones

---

## Use a Set

- Values must be unique.
- Order does not matter.
- You want Terraform to automatically remove duplicates.

Examples:

- IAM usernames
- Security group IDs
- CIDR blocks
- AWS Availability Zones (when order is not important)

---

# Best Practices

- Use **lists** when element order is significant.
- Use **sets** when uniqueness is more important than ordering.
- Avoid converting between lists and sets unless necessary.
- Remember that sets cannot be indexed.

---

# Summary

| Data Type | Ordered | Duplicates | Indexing |
|-----------|:-------:|:----------:|:--------:|
| `list` | ✅ Yes | ✅ Yes | ✅ Yes |
| `set` | ❌ No | ❌ No | ❌ No |

---

# Key Takeaways

- A **List** is an ordered collection that allows duplicate values and supports indexing.
- A **Set** is an unordered collection of unique values with no indexing support.
- Choose the data type based on whether **order** or **uniqueness** is more important for your Terraform configuration.
