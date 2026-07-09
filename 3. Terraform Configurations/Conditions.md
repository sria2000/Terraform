# Terraform Conditional Expressions

## Overview

Conditional expressions allow Terraform to make decisions based on the value of variables or expressions.

Instead of maintaining multiple Terraform configurations for different environments, you can use a **single configuration** that dynamically selects values at runtime.

### Common Use Cases

- Deploy different EC2 instance sizes for Development and Production.
- Enable or disable resources.
- Select AMIs based on region.
- Configure different storage sizes.
- Enable monitoring only in Production.
- Configure backup policies.

---

## Documentation

- Terraform Expressions Documentation:
  https://developer.hashicorp.com/terraform/language/expressions/conditionals

---

# Conditional Expression Syntax

Terraform uses the following syntax:

```hcl
condition ? true_value : false_value
```

If the condition evaluates to **true**, Terraform returns the **true value**.

If the condition evaluates to **false**, Terraform returns the **false value**.

General syntax:

```hcl
variable == "value" ? "True Result" : "False Result"
```

---

# Why Use Conditional Expressions?

Without conditional expressions, you might need multiple Terraform files:

```
dev.tf

prod.tf

test.tf
```

Instead, a single Terraform configuration can automatically select the correct values.

Example:

| Environment | Instance Type |
|-------------|---------------|
| Development | t2.micro |
| Production | m5.large |

---

# Example 1 - Hardcoded EC2 Instance

## Base Code

```hcl
variable "environment" {
  default = "development"
}

resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
}
```

### Explanation

The instance type is hardcoded.

Regardless of the environment, Terraform always creates:

```text
t2.micro
```

---

# Example 2 - Conditional Expression

```hcl
variable "environment" {
  default = "production"
}

resource "aws_instance" "myec2" {

  ami = "ami-00c39f71452c08778"

  instance_type = var.environment == "development" ? "t2.micro" : "m5.large"

}
```

### Explanation

Terraform evaluates:

```hcl
var.environment == "development"
```

If the condition is:

**True**

```text
t2.micro
```

If the condition is:

**False**

```text
m5.large
```

Since:

```text
environment = production
```

Terraform creates:

```text
m5.large
```

---

# Visual Representation

```text
Environment

production

      │

      ▼

Is Environment = development?

      │

   FALSE

      │

      ▼

Launch

m5.large
```

---

# Example 3 - Using NOT Equal (`!=`)

```hcl
variable "environment" {
  default = "production"
}

resource "aws_instance" "myec2" {

  ami = "ami-00c39f71452c08778"

  instance_type = var.environment != "development" ? "t2.micro" : "m5.large"

}
```

### Explanation

Condition:

```hcl
var.environment != "development"
```

When:

```text
environment = production
```

The condition is **true**.

Terraform launches:

```text
t2.micro
```

If:

```text
environment = development
```

Then:

```text
development != development
```

becomes **false**.

Terraform launches:

```text
m5.large
```

---

# Example 4 - Checking for Empty Strings

```hcl
instance_type = var.environment != "" ? "t2.micro" : "m5.large"
```

### Explanation

If the variable contains any value:

```text
production
development
test
```

Terraform selects:

```text
t2.micro
```

If the value is empty:

```text
""
```

Terraform selects:

```text
m5.large
```

### Example

| Environment Value | Result |
|-------------------|--------|
| production | t2.micro |
| development | t2.micro |
| "" | m5.large |

---

# Example 5 - Multiple Conditions

Terraform supports combining multiple conditions using logical operators.

## Variables

```hcl
variable "environment" {
  default = "production"
}

variable "region" {
  default = "ap-south-1"
}
```

## Resource

```hcl
resource "aws_instance" "myec2" {

  ami = "ami-00c39f71452c08778"

  instance_type = var.environment == "production" &&
                  var.region == "us-east-1"
                  ? "m5.large"
                  : "t2.micro"

}
```

### Decision Table

| Environment | Region | Instance Type |
|-------------|--------|---------------|
| production | us-east-1 | m5.large |
| production | ap-south-1 | t2.micro |
| development | us-east-1 | t2.micro |
| development | ap-south-1 | t2.micro |

Since:

```
Environment = production

Region = ap-south-1
```

Terraform launches:

```text
t2.micro
```

---

# Example 6 - Creating Resources Conditionally

Conditional expressions are frequently used with the **`count` meta-argument** to create or skip resources.

## Terraform Configuration

### `conditional.tf`

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

variable "istest" {}

resource "aws_instance" "dev" {

  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"

  count = var.istest == true ? 3 : 0

}

resource "aws_instance" "prod" {

  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.large"

  count = var.istest == false ? 1 : 0

}
```

### `terraform.tfvars`

```hcl
istest = false
```

---

## How It Works

### When:

```hcl
istest = true
```

Terraform evaluates:

```hcl
count = var.istest == true ? 3 : 0
```

Result:

- 3 Development EC2 instances
- 0 Production EC2 instances

---

### When:

```hcl
istest = false
```

Terraform evaluates:

```hcl
count = var.istest == false ? 1 : 0
```

Result:

- 0 Development EC2 instances
- 1 Production EC2 instance

---

## Resource Creation Flow

### `istest = true`

```text
Is Test Environment?

        │
      TRUE
        │
        ▼

Create

3 × t2.micro

Skip Production
```

---

### `istest = false`

```text
Is Test Environment?

        │
      FALSE
        │
        ▼

Skip Development

Create

1 × t2.large
```

---

# Logical Operators

## AND (`&&`)

Both conditions must be true.

```hcl
var.environment == "production" &&
var.region == "us-east-1"
```

---

## OR (`||`)

At least one condition must be true.

```hcl
var.environment == "production" ||
var.region == "us-east-1"
```

---

## NOT Equal (`!=`)

Checks whether two values are different.

```hcl
var.environment != "development"
```

---

# Conditional Expression Flow

```text
           Condition

               │

        Is it TRUE?

         /         \

      Yes           No

       │             │

 True Value     False Value
```

---

# Real-World Examples

## Environment-based EC2

```hcl
instance_type = var.environment == "production"
                ? "m5.large"
                : "t2.micro"
```

---

## Database Storage

```hcl
allocated_storage = var.environment == "production"
                    ? 100
                    : 20
```

Production:

```text
100 GB
```

Development:

```text
20 GB
```

---

## Enable Monitoring

```hcl
monitoring = var.environment == "production"
```

---

## Create Resources Only in Production

```hcl
count = var.environment == "production" ? 1 : 0
```

---

# Best Practices

- Keep conditional expressions simple and readable.
- Use variables instead of hardcoded values.
- Use logical operators (`&&`, `||`) for multiple conditions.
- Avoid deeply nested conditional expressions.
- Use conditional expressions with `count` or `for_each` to control resource creation.

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

| Feature | Description |
|---------|-------------|
| Conditional Expression | Returns one of two values based on a condition |
| Syntax | `condition ? true_value : false_value` |
| Common Operators | `==`, `!=`, `&&`, `||` |
| Typical Uses | Environment selection, resource creation, storage sizing, feature toggles |

---

# Key Takeaways

- Conditional expressions allow Terraform to make decisions dynamically.
- They reduce duplication by enabling a single configuration to support multiple environments.
- Use the syntax `condition ? true_value : false_value`.
- Combine conditions with logical operators for more complex decisions.
- Conditional expressions work particularly well with the `count` meta-argument to create or skip resources based on environment or other variables.
