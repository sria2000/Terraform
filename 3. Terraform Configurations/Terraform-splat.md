# Terraform Splat Expression

## What is a Splat Expression?

A **Splat Expression** is a Terraform expression used to retrieve an attribute from **all resources in a list**.

Instead of accessing each resource individually, the splat operator (`[*]`) collects the same attribute from every instance and returns them as a list.

This makes your code shorter, cleaner, and easier to maintain.

---

## Documentation

https://developer.hashicorp.com/terraform/language/expressions/splat

---

# Syntax

```hcl
resource_name[*].attribute
```

Example:

```hcl
aws_iam_user.lb[*].arn
```

This returns the **ARN of every IAM user** created by the resource.

---

# Example

## Terraform Configuration

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

resource "aws_iam_user" "lb" {
  name  = "iamuser.${count.index}"
  count = 3
  path  = "/system/"
}

output "arns" {
  value = aws_iam_user.lb[*].arn
}
```

---

## Resources Created

Since:

```hcl
count = 3
```

Terraform creates three IAM users:

```text
iamuser.0
iamuser.1
iamuser.2
```

The `count.index` starts at **0** and increments for each resource instance.

---

## Splat Expression

```hcl
aws_iam_user.lb[*].arn
```

The `[*]` operator tells Terraform to retrieve the `arn` attribute from **every** IAM user created by the resource.

Equivalent to:

```text
aws_iam_user.lb[0].arn
aws_iam_user.lb[1].arn
aws_iam_user.lb[2].arn
```

Terraform combines these into a single list.

---

## Sample Output

```text
arns = [
  "arn:aws:iam::123456789012:user/iamuser.0",
  "arn:aws:iam::123456789012:user/iamuser.1",
  "arn:aws:iam::123456789012:user/iamuser.2"
]
```

---

# Without Splat Expression

```hcl
output "arns" {
  value = [
    aws_iam_user.lb[0].arn,
    aws_iam_user.lb[1].arn,
    aws_iam_user.lb[2].arn
  ]
}
```

This works but becomes difficult to maintain as the number of resources grows.

---

# With Splat Expression

```hcl
output "arns" {
  value = aws_iam_user.lb[*].arn
}
```

This automatically returns the ARN of every IAM user, regardless of how many are created.

---

# When to Use Splat Expressions

Use splat expressions when you need to retrieve the same attribute from multiple resources created using:

- `count`
- `for_each` (with appropriate expressions)
- Lists of objects

Common attributes include:

- IDs
- ARNs
- IP addresses
- Names
- DNS names

---

# Advantages

- Reduces repetitive code.
- Makes configurations cleaner and easier to read.
- Automatically adapts when the number of resources changes.
- Returns a list of attribute values.

---

# Key Points

- The splat operator is written as `[*]`.
- It retrieves an attribute from every resource instance in a list.
- Commonly used with resources created using `count`.
- In this example, `count.index` starts at **0**, creating:
  - `iamuser.0`
  - `iamuser.1`
  - `iamuser.2`
- `aws_iam_user.lb[*].arn` returns a list containing the ARN of each IAM user.
