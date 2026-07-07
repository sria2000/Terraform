# Conditional Expressions in Terraform

## Documentation Referred

Terraform Expressions Documentation:

https://developer.hashicorp.com/terraform/language/expressions/conditionals

---

# Overview

Conditional expressions allow Terraform to make decisions based on variable values.

This is useful when deploying infrastructure for different environments.

Example:

- **Development** → Small EC2 Instance (`t2.micro`)
- **Production** → Large EC2 Instance (`m5.large`)

Instead of maintaining multiple Terraform files, a single configuration can dynamically choose the appropriate resource configuration.

---

# Conditional Expression Syntax

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

# Example 1 - Basic EC2 Instance

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
  ami           = "ami-00c39f71452c08778"

  instance_type = var.environment == "development" ? "t2.micro" : "m5.large"
}
```

### Explanation

Condition:

```hcl
var.environment == "development"
```

If **true**

```text
t2.micro
```

If **false**

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

# Example 3 - Using NOT Equal (!=)

```hcl
variable "environment" {
  default = "production"
}

resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"

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

Condition is **true**.

Terraform launches:

```text
t2.micro
```

---

If you change:

```hcl
default = "development"
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

Condition:

```hcl
var.environment != ""
```

If the variable contains any value (is not empty), Terraform selects:

```text
t2.micro
```

If the variable is an empty string (`""`), Terraform selects:

```text
m5.large
```

Example:

| Environment Value | Result |
|-------------------|--------|
| `"production"` | `t2.micro` |
| `"development"` | `t2.micro` |
| `""` | `m5.large` |

---

# Example 5 - Multiple Conditional Expressions

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

  instance_type = var.environment == "production" && var.region == "us-east-1" ? "m5.large" : "t2.micro"

}
```

---

# Explanation

Condition:

```text
Environment == production

AND

Region == us-east-1
```

Both conditions must be **true**.

Decision table:

| Environment | Region | Instance Type |
|-------------|--------|---------------|
| production | us-east-1 | m5.large |
| production | ap-south-1 | t2.micro |
| development | us-east-1 | t2.micro |
| development | ap-south-1 | t2.micro |

Since:

```text
Environment = production
Region = ap-south-1
```

Second condition is false.

Terraform creates:

```text
t2.micro
```

---

# Logical Operators

## AND (&&)

Both conditions must be true.

```hcl
var.environment == "production" && var.region == "us-east-1"
```

---

## OR (||)

At least one condition must be true.

Example:

```hcl
instance_type = var.environment == "production" || var.region == "us-east-1" ? "m5.large" : "t2.micro"
```

---

## NOT Equal (!=)

Checks whether two values are different.

Example:

```hcl
var.environment != "development"
```

---

# Conditional Expression Flow

```text
          Condition

               │

      Is it TRUE ?

        /         \

     Yes           No

      │             │

True Value     False Value
```

---

# Real-World Use Cases

Conditional expressions are commonly used for:

- Selecting EC2 instance types.
- Choosing AMIs based on region.
- Creating resources only for production.
- Selecting storage sizes.
- Enabling or disabling monitoring.
- Configuring backup policies.

Example:

```hcl
allocated_storage = var.environment == "production" ? 100 : 20
```

Production database:

```text
100 GB
```

Development database:

```text
20 GB
```

---

# Best Practices

- Keep conditional expressions simple and readable.
- Use variables instead of hardcoded values.
- Use logical operators (`&&`, `||`) for multiple conditions.
- Avoid deeply nested conditional expressions, as they become difficult to maintain.

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

- What conditional expressions are.
- The syntax of Terraform conditional expressions.
- Using equality (`==`) and inequality (`!=`) operators.
- Checking for empty values.
- Combining multiple conditions using logical operators.
- Real-world examples for selecting EC2 instance types based on environment and region.
- Best practices for writing clean and maintainable conditional expressions.
