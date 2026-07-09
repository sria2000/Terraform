# Terraform Input Variable Validation

Terraform **Input Variable Validation** allows you to enforce rules and constraints on the values assigned to input variables.

Instead of allowing any value, Terraform validates the input before creating an execution plan or applying infrastructure changes.

This helps catch configuration errors early and provides meaningful error messages to users.

---

# Why Use Input Variable Validation?

Without validation, invalid input values may cause:

- Failed deployments
- Provider errors
- Resource creation failures
- Unexpected behaviour

By validating input variables, Terraform ensures that only acceptable values are used.

---

# Benefits of Input Variable Validation

- Enforces consistency across Terraform configurations.
- Makes infrastructure code more predictable.
- Catches misconfigurations early.
- Provides clear error messages.
- Prevents invalid values from reaching cloud providers.

---

# How Validation Works

A validation rule is defined inside the variable block.

Terraform evaluates the validation **condition**, which must return a Boolean value:

- `true` → Validation succeeds.
- `false` → Terraform stops and displays the specified error message.

Syntax:

```hcl
variable "variable_name" {

  type = string

  validation {

    condition = <boolean expression>

    error_message = "Custom error message"

  }

}
```

---

# Validation Block

A validation block contains two arguments:

| Argument | Description |
|----------|-------------|
| `condition` | Boolean expression that evaluates to `true` or `false` |
| `error_message` | Custom error shown when validation fails |

---

# Example 1 – Provider Validation

Terraform providers also perform their own validation.

Consider the following IAM user:

```hcl
terraform {

  required_providers {

    aws = "~> 5.6"

  }

}

resource "aws_iam_user" "dev" {

    name = "kplabs-user-01#"

}
```

Running:

```bash
terraform plan
```

Terraform fails because the AWS provider validates IAM usernames.

The character:

```text
#
```

is **not permitted** in an IAM user name.

This validation is performed by the AWS provider rather than by Terraform input variables.

---

# Example 2 – Input Variable Validation

Suppose you want every database password to contain at least **12 characters**.

Without validation, users could accidentally enter weak passwords.

---

## Variable Definition

```hcl
variable "db_password" {

  type = string

  validation {

    condition = length(var.db_password) >= 12

    error_message = "Length of Database Password must be equal to or greater than 12 characters"

  }

}
```

---

# Understanding the Validation

Terraform evaluates:

```hcl
length(var.db_password) >= 12
```

If the password length is:

- 12 or more → Validation succeeds.
- Less than 12 → Validation fails.

---

# Valid Input

Example:

```text
MyStrongPassword123
```

Length:

```text
19
```

Condition:

```text
19 >= 12
```

Result:

```text
true
```

Terraform continues.

---

# Invalid Input

Example:

```text
password
```

Length:

```text
8
```

Condition:

```text
8 >= 12
```

Result:

```text
false
```

Terraform displays:

```text
Error:

Length of Database Password must be equal to or greater than 12 characters
```

---

# Validation Flow

```text
User Input
     │
     ▼
Validation Condition
     │
     ├── TRUE
     │      │
     │      ▼
     │  Continue Terraform
     │
     └── FALSE
            │
            ▼
     Display Error Message
```

---

# Common Validation Functions

Terraform supports many functions that can be used inside validation conditions.

Examples include:

| Function | Purpose |
|----------|---------|
| `length()` | Checks string or collection length |
| `contains()` | Checks whether a value exists in a collection |
| `startswith()` | Verifies a string starts with a specific value |
| `endswith()` | Verifies a string ends with a specific value |
| `can()` | Tests whether an expression can be evaluated |
| `regex()` | Validates values using regular expressions |

---

# Additional Validation Examples

## Minimum Length

```hcl
validation {

  condition = length(var.username) >= 5

  error_message = "Username must contain at least 5 characters."

}
```

---

## Allowed Values

```hcl
validation {

  condition = contains(
    ["dev", "test", "prod"],
    var.environment
  )

  error_message = "Environment must be dev, test, or prod."

}
```

---

## Prefix Validation

```hcl
validation {

  condition = startswith(var.bucket_name, "company-")

  error_message = "Bucket name must start with company-."

}
```

---

# Best Practices

- Validate all important user inputs.
- Provide meaningful error messages.
- Keep validation rules simple and easy to understand.
- Validate values before they reach cloud providers.
- Use validation to enforce organizational naming conventions and security standards.

---

# Summary

| Feature | Description |
|---------|-------------|
| Validation Block | Defines rules for input variables |
| `condition` | Boolean expression that must evaluate to `true` |
| `error_message` | Displayed when validation fails |
| Purpose | Prevent invalid input values |

---

# Key Takeaways

- Input variable validation allows Terraform to enforce constraints on variable values.
- Validation helps catch configuration mistakes before infrastructure is created or modified.
- A validation rule consists of a Boolean `condition` and a custom `error_message`.
- Provider validation (such as AWS naming rules) and Terraform input validation complement each other to improve reliability and consistency.

---

# Documentation

Terraform Input Variable Validation

https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules

AWS IAM User Resource

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user

Amazon S3 Bucket Naming Rules

https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
