# Terraform Functions

## Documentation Referred

Terraform Functions Documentation:

https://developer.hashicorp.com/terraform/language/functions

---

# Overview

Terraform provides a large collection of **built-in functions** that perform specific tasks such as:

- Mathematical calculations
- String manipulation
- File operations
- Collection operations
- Encoding and decoding data
- Date and time operations

Functions help reduce code duplication and make Terraform configurations cleaner and easier to maintain.

> **Note:** Terraform supports **only built-in functions**. It does **not** support user-defined functions.

---

# Function Syntax

```hcl
function_name(argument1, argument2, ...)
```

Example:

```hcl
max(10, 20, 30)
```

Output:

```text
30
```

---

# Example 1 - Numeric Function

```hcl
max(10,20,30)
```

Output

```text
30
```

### Explanation

The `max()` function returns the largest value from the list of numbers.

More examples:

```hcl
min(5,20,100)
```

Output

```text
5
```

---

# Example 2 - File Function

The **file()** function reads the contents of a file and returns it as a string.

Syntax:

```hcl
file("./filename")
```

Example:

```hcl
file("./random-file.txt")
```

Suppose the file contains:

```text
Test file in folder
```

The function returns:

```text
"Test file in folder"
```

---

# Terraform Console

Terraform provides an interactive console for testing:

- Functions
- Variables
- Expressions

without running a Terraform deployment.

Start the console:

```bash
terraform console
```

Example:

```text
PS D:\Terraform\TERRAFORMLAB> terraform console

> file("./a.txt")
"this is a file"

> max(10,100,1000)
1000
```

Exit the console:

```text
> exit
```

or press:

```text
Ctrl + C
```

---

# File Function

The **file()** function is commonly used to load external files during Terraform execution.

Typical use cases include:

- IAM Policies
- SSH Public Keys
- Cloud-init Scripts
- User Data Scripts
- JSON Templates

Instead of embedding long JSON or scripts inside Terraform files, they can be stored separately and loaded using the `file()` function.

---

# Example - IAM Policy Without file()

## Base Code (functions.tf)

```hcl
resource "aws_iam_user" "this" {
  name = "demo-kplabs-user"
}

resource "aws_iam_user_policy" "lb_ro" {

  name = "demo-user-policy"

  user = aws_iam_user.this.name

  policy = jsonencode({

    "Version": "2012-10-17",

    "Statement": [

      {
        "Action":"ec2:*",
        "Effect":"Allow",
        "Resource":"*"
      },

      {
        "Effect":"Allow",
        "Action":"elasticloadbalancing:*",
        "Resource":"*"
      },

      {
        "Effect":"Allow",
        "Action":"cloudwatch:*",
        "Resource":"*"
      },

      {
        "Effect":"Allow",
        "Action":"autoscaling:*",
        "Resource":"*"
      },

      {
        "Effect":"Allow",
        "Action":"iam:CreateServiceLinkedRole",
        "Resource":"*",
        "Condition":{
          "StringEquals":{
            "iam:AWSServiceName":[
              "autoscaling.amazonaws.com",
              "ec2scheduled.amazonaws.com",
              "elasticloadbalancing.amazonaws.com",
              "spot.amazonaws.com",
              "spotfleet.amazonaws.com",
              "transitgateway.amazonaws.com"
            ]
          }
        }
      }

    ]

  })

}
```

### Drawback

Embedding large JSON policies inside Terraform files makes the code:

- Difficult to read
- Hard to maintain
- Harder to reuse

---

# Better Approach - Using file()

## functions.tf

```hcl
resource "aws_iam_user" "this" {

  name = "demo-kplabs-user"

}

resource "aws_iam_user_policy" "lb_ro" {

  name = "demo-user-policy"

  user = aws_iam_user.this.name

  policy = file("./iam-user-policy.json")

}
```

Now the policy is stored separately.

---

# iam-user-policy.json

```json
{
  "Version": "2012-10-17",
  "Statement": [

    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:*",
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": "cloudwatch:*",
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": "autoscaling:*",
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": [
            "autoscaling.amazonaws.com",
            "ec2scheduled.amazonaws.com",
            "elasticloadbalancing.amazonaws.com",
            "spot.amazonaws.com",
            "spotfleet.amazonaws.com",
            "transitgateway.amazonaws.com"
          ]
        }
      }
    }

  ]
}
```

---

# How file() Works

```text
Terraform

        │

        ▼

file("./iam-user-policy.json")

        │

Reads File

        │

        ▼

Returns JSON as String

        │

        ▼

AWS IAM Policy Created
```

---

# Benefits of Using file()

- Cleaner Terraform code
- Easier to maintain
- JSON can be reused
- Better readability
- Easier version control
- Separation of infrastructure and configuration

---

# Commonly Used Terraform Functions

## Numeric Functions

| Function | Description |
|----------|-------------|
| max() | Returns the largest number |
| min() | Returns the smallest number |
| abs() | Returns absolute value |
| ceil() | Rounds up |
| floor() | Rounds down |

Example:

```hcl
max(5,20,100)
```

---

## String Functions

| Function | Description |
|----------|-------------|
| upper() | Converts to uppercase |
| lower() | Converts to lowercase |
| length() | Returns string length |
| replace() | Replaces text |
| substr() | Extracts part of a string |

Example:

```hcl
upper("terraform")
```

Output:

```text
TERRAFORM
```

---

## Collection Functions

Used with:

- Lists
- Maps
- Sets

Examples:

| Function | Description |
|----------|-------------|
| keys() | Returns map keys |
| values() | Returns map values |
| lookup() | Retrieves map value |
| contains() | Checks if a value exists |
| length() | Counts elements |

---

## Filesystem Functions

| Function | Description |
|----------|-------------|
| file() | Reads a file |
| fileexists() | Checks if a file exists |
| fileset() | Returns matching filenames |
| dirname() | Returns directory path |
| basename() | Returns filename |

---

## Encoding Functions

| Function | Description |
|----------|-------------|
| jsonencode() | Converts Terraform object to JSON |
| jsondecode() | Converts JSON to Terraform object |
| base64encode() | Encodes Base64 |
| base64decode() | Decodes Base64 |

---

## Date and Time Functions

Examples:

- timestamp()
- formatdate()

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
terraform apply -auto-approve
```

---

# Best Practices

- Use built-in functions wherever possible.
- Store large JSON files separately and load them using `file()`.
- Use `terraform console` to experiment with functions before adding them to your configuration.
- Keep Terraform code focused on infrastructure and externalize large configuration files.

---

# Summary

This document demonstrated:

- What Terraform functions are.
- Using the `max()` numeric function.
- Using the `file()` filesystem function.
- Testing functions with `terraform console`.
- Separating IAM policies into external JSON files.
- Benefits of the `file()` function.
- Common categories of Terraform built-in functions.
- Terraform does **not** support user-defined functions; only built-in functions are available.
