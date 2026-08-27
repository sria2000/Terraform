# Terraform Variables - List Data Type

## Documentation Referred

Terraform AWS Provider Documentation:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

---

# Overview

Terraform variables allow you to pass values into your configuration, making your code reusable and flexible.

This document demonstrates:

- Assigning variables
- Using the `list` data type
- Passing multiple values
- Using lists with AWS EC2 resources
- Restricting list elements to numbers

---

# Example 1 - Assign a Variable

## Terraform Configuration

```hcl
variable "sri-list" {}

output "variable_value" {
  value = var.sri-list
}
```

### Output

```text
PS D:\Terraform\TERRAFORMLAB> terraform plan

var.sri-list
  Enter a value: Sri

Changes to Outputs:
  + variable_value = "Sri"
```

### Explanation

- The variable has no data type restriction.
- Terraform prompts the user to enter a value during execution.
- Whatever value is entered is displayed in the output.

---

# Example 2 - List Data Type

## Terraform Configuration

```hcl
variable "sri-list" {
  type = list
}

output "variable_value" {
  value = var.sri-list
}
```

### Output

```text
PS D:\Terraform\TERRAFORMLAB> terraform plan

var.sri-list
  Enter a value: ["test","hello"]

Changes to Outputs:
  + variable_value = [
      + "test",
      + "hello",
    ]
```

### Explanation

- `type = list` restricts the variable to accept only a list.
- Values must be enclosed in square brackets `[]`.
- Multiple values can be stored in a single variable.

Example:

```hcl
["test", "hello"]
```

---

# Example 3 - EC2 Example with Multiple Security Groups

```hcl
resource "aws_instance" "web" {
  ami                    = "ami-123"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-1234", "sg-5678"]
}
```

### Explanation

The `vpc_security_group_ids` argument accepts a list.

In this example, the EC2 instance is associated with two security groups:

- sg-1234
- sg-5678

Visual representation:

```text
EC2 Instance
     │
     ├── Security Group: sg-1234
     └── Security Group: sg-5678
```

---

# Example 4 - List Variable with Default Values

```hcl
variable "city-list" {
  type    = list
  default = ["Chennai", "Mumbai", "Delhi"]
}
```

### Explanation

This variable:

- Uses the `list` data type.
- Has three default values.
- Does not prompt the user unless overridden.

Default list:

```text
Chennai
Mumbai
Delhi
```

---

# Example 5 - Single Value List

```hcl
resource "aws_instance" "web" {
  ami                    = "ami-123"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-1234"]
}
```

### Note

Even if there is only one value, it **must** be enclosed in square brackets because `vpc_security_group_ids` expects a list.

Correct:

```hcl
vpc_security_group_ids = ["sg-1234"]
```

Incorrect:

```hcl
vpc_security_group_ids = "sg-1234"
```

---

# Example 6 - List(Number) Data Type Restriction

```hcl
variable "my-list" {
  type    = list(number)
  default = [1, 2, 3]
}
```

### Explanation

The `list(number)` type allows only numeric values.

Correct:

```hcl
default = [1, 2, 3]
```

Incorrect:

```hcl
default = ["1", "2", "3"]
```

The incorrect example uses strings instead of numbers and will result in a type validation error.

---

# Common Terraform List Data Types

| Data Type | Example |
|-----------|---------|
| `list(string)` | `["Dev", "Prod"]` |
| `list(number)` | `[1, 2, 3]` |
| `list(bool)` | `[true, false]` |

---

# When to Use Lists

Lists are commonly used for:

- Security Group IDs
- Availability Zones
- Subnet IDs
- IP Addresses
- Tags
- Multiple EC2 Instances
- DNS Servers

Example:

```hcl
variable "availability_zones" {
  type = list(string)
}

default = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]
```

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

- Assigning variables in Terraform.
- Using the `list` data type.
- Passing multiple values to a variable.
- Creating list variables with default values.
- Associating multiple security groups with an EC2 instance.
- Using a single value inside a list.
- Restricting list elements using `list(number)`.
- Common use cases for Terraform lists.
