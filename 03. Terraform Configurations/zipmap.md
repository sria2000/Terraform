# Terraform `zipmap()` Function

The `zipmap()` function creates a **map** by combining **two lists**:

- The **first list** becomes the **keys**
- The **second list** becomes the **values**

It is useful when you have two related lists and want to convert them into a key-value map.

---

# Syntax

```hcl
zipmap(keys, values)
```

Where:

- `keys` → List of map keys
- `values` → List of corresponding values

Both lists **must contain the same number of elements**.

---

# Simple Example

Open the Terraform console:

```bash
terraform console
```

Run the following command:

```hcl
zipmap(
  ["pineapple", "oranges", "strawberry"],
  ["yellow", "orange", "red"]
)
```

Output:

```hcl
{
  "oranges"   = "orange"
  "pineapple" = "yellow"
  "strawberry" = "red"
}
```

---

# How It Works

## List of Keys

```text
[
  pineapple,
  oranges,
  strawberry
]
```

## List of Values

```text
[
  yellow,
  orange,
  red
]
```

Terraform combines both lists **position by position**.

| Key | Value |
|------|-------|
| pineapple | yellow |
| oranges | orange |
| strawberry | red |

Result:

```hcl
{
  pineapple = yellow
  oranges   = orange
  strawberry = red
}
```

---

# Another Simple Example

```hcl
zipmap(
  ["dev", "test", "prod"],
  ["10.0.0.1", "10.0.0.2", "10.0.0.3"]
)
```

Output:

```hcl
{
  "dev"  = "10.0.0.1"
  "test" = "10.0.0.2"
  "prod" = "10.0.0.3"
}
```

---

# Practical Example

Suppose Terraform creates three IAM users.

## Configuration

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

resource "aws_iam_user" "lb" {
  count = 3

  name = "demo-user.${count.index}"
  path = "/system/"
}

output "arns" {
  value = aws_iam_user.lb[*].arn
}

output "zipmap" {
  value = zipmap(
    aws_iam_user.lb[*].name,
    aws_iam_user.lb[*].arn
  )
}
```

---

# Step 1 – User Names

Terraform creates three users.

```text
demo-user.0
demo-user.1
demo-user.2
```

---

# Step 2 – ARNs

Terraform also generates their ARNs.

```text
arn:aws:iam::123456789012:user/system/demo-user.0

arn:aws:iam::123456789012:user/system/demo-user.1

arn:aws:iam::123456789012:user/system/demo-user.2
```

---

# Step 3 – zipmap()

Terraform executes:

```hcl
zipmap(
  aws_iam_user.lb[*].name,
  aws_iam_user.lb[*].arn
)
```

---

# Result

Terraform combines each username with its corresponding ARN.

```hcl
{
  "demo-user.0" = "arn:aws:iam::123456789012:user/system/demo-user.0"
  "demo-user.1" = "arn:aws:iam::123456789012:user/system/demo-user.1"
  "demo-user.2" = "arn:aws:iam::123456789012:user/system/demo-user.2"
}
```

---

# Why Use `zipmap()`?

The `zipmap()` function is useful when you need to:

- Convert two related lists into a map.
- Associate resource names with their IDs or ARNs.
- Build lookup tables.
- Create structured outputs for other modules.
- Simplify data transformations in Terraform.

---

# Common Use Cases

- Username → ARN
- EC2 Name → Instance ID
- Server Name → Private IP
- Environment → CIDR Block
- Region → Availability Zone
- Database Name → Endpoint

---

# Important Notes

- Both lists **must have the same length**.
- The first list becomes the map keys.
- The second list becomes the map values.
- Duplicate keys are not recommended, as later values will overwrite earlier ones.

---

# Summary

| Function | Description |
|----------|-------------|
| `zipmap(keys, values)` | Combines two lists into a map |
| First list | Becomes the map keys |
| Second list | Becomes the map values |
| List sizes | Must be equal |

---

# Example Recap

Input:

```hcl
zipmap(
  ["pineapple", "oranges", "strawberry"],
  ["yellow", "orange", "red"]
)
```

Output:

```hcl
{
  "pineapple" = "yellow"
  "oranges"   = "orange"
  "strawberry" = "red"
}
```

---

# Documentation

Terraform `zipmap()` Function

https://developer.hashicorp.com/terraform/language/functions/zipmap
