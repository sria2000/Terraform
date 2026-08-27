# Terraform Precondition and Postcondition

Terraform supports **Preconditions** and **Postconditions** to validate resources before and after they are created.

These checks are part of the **`lifecycle` meta-argument** and allow you to enforce custom rules that go beyond normal variable validation.

Introduced in **Terraform 1.2**, they help ensure your infrastructure meets business, security, and operational requirements.

---

# Why Use Preconditions and Postconditions?

Sometimes validating an input variable is not enough.

Examples:

- Launch an EC2 instance **only if it is Free Tier eligible**.
- Ensure an EC2 instance **receives a public IP address** after creation.
- Verify an AMI belongs to your organization.
- Confirm an EBS volume is encrypted.
- Ensure a load balancer is internet-facing.

Terraform allows you to validate these conditions using **preconditions** and **postconditions**.

---

# Precondition vs Postcondition

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| Checked | Before Terraform creates or updates the resource | After Terraform creates or reads the resource |
| Purpose | Validate inputs or prerequisites | Validate the resulting infrastructure |
| Uses | Prevent invalid deployments | Verify the deployed resource meets expectations |

---

# Precondition

A **precondition** checks a condition **before** Terraform creates or updates a resource.

If the condition evaluates to **false**, Terraform stops immediately and displays the specified error message.

### Example

> Launch an EC2 instance **only if the selected instance type is Free Tier eligible**.

---

# Base Code

```hcl
data "aws_ec2_instance_type" "example" {
  instance_type = "t2.micro"
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-066784287e358dad1"
}
```

This configuration creates an EC2 instance without any validation.

---

# Final Code

```hcl
variable "instance_type" {}

data "aws_ec2_instance_type" "example" {
  instance_type = var.instance_type
}

resource "aws_instance" "example" {

  instance_type = var.instance_type
  ami           = "ami-1234"

  lifecycle {

    precondition {

      condition = data.aws_ec2_instance_type.example.free_tier_eligible

      error_message = "Select only free tier eligible"

    }

  }

}
```

---

# How It Works

Terraform first evaluates:

```hcl
data.aws_ec2_instance_type.example.free_tier_eligible
```

If the selected instance type is:

```text
Free Tier Eligible
```

Terraform continues.

If not:

```text
Terraform stops.
```

Example error:

```text
Error:

Select only free tier eligible
```

---

# Precondition Execution Flow

```text
User selects instance type
           │
           ▼
Read AWS Instance Type Data
           │
           ▼
Is Free Tier Eligible?
           │
     ┌─────┴─────┐
     │           │
    Yes          No
     │           │
     ▼           ▼
Create EC2   Display Error
```

---

# Postcondition

A **postcondition** checks a condition **after** Terraform has created or refreshed a resource.

This is useful when validating the final state of the infrastructure.

### Example

Ensure the EC2 instance has a **public IPv4 address or DNS name** after creation.

---

# Example Configuration

```hcl
data "aws_ec2_instance_type" "example" {
  instance_type = "t3.micro"
}

output "instance_type" {
  value = data.aws_ec2_instance_type.example.free_tier_eligible
}

resource "aws_instance" "example" {

  instance_type = "t2.micro"
  ami           = "ami-066784287e358dad1"

  lifecycle {

    precondition {

      condition = data.aws_ec2_instance_type.example.free_tier_eligible

      error_message = "Instance Type is not part of free tier"

    }

    postcondition {

      condition = self.public_dns != ""

      error_message = "Public IPv4 or DNS is mandatory for this server"

    }

  }

}
```

> **Note:** The original example used:
>
> ```hcl
> self.public_dns == ""
> ```
>
> To enforce that a public DNS **must exist**, the condition should be:
>
> ```hcl
> self.public_dns != ""
> ```

---

# Understanding `self`

Inside a postcondition, Terraform provides the special object:

```hcl
self
```

`self` refers to the resource currently being evaluated.

Examples:

```hcl
self.id
```

```hcl
self.public_ip
```

```hcl
self.public_dns
```

```hcl
self.instance_type
```

---

# Postcondition Execution Flow

```text
Create EC2 Instance
         │
         ▼
Read Resource Attributes
         │
         ▼
Does Public DNS Exist?
         │
    ┌────┴────┐
    │         │
   Yes        No
    │         │
    ▼         ▼
Success   Display Error
```

---

# Common Use Cases

## Preconditions

Use preconditions to verify:

- Free Tier eligibility
- Correct AWS region
- AMI owner
- Supported instance types
- Required subnet exists
- Valid security group

---

## Postconditions

Use postconditions to verify:

- Public IP assigned
- Public DNS assigned
- EBS encryption enabled
- Correct tags applied
- Correct availability zone
- Resource state after deployment

---

# Precondition vs Variable Validation

| Variable Validation | Precondition |
|---------------------|--------------|
| Validates user input | Validates resource requirements |
| Runs before planning | Runs before creating the resource |
| Uses variable values | Can reference data sources and resources |

Example:

Variable validation:

```hcl
length(var.password) >= 12
```

Precondition:

```hcl
data.aws_ec2_instance_type.example.free_tier_eligible
```

---

# Best Practices

- Use **variable validation** for validating user inputs.
- Use **preconditions** to verify deployment prerequisites.
- Use **postconditions** to verify the final infrastructure state.
- Keep error messages clear and actionable.
- Use data sources to evaluate conditions whenever possible.

---

# Summary

| Condition | When Checked | Purpose |
|-----------|--------------|---------|
| Variable Validation | Before planning | Validate user input |
| Precondition | Before resource creation | Validate deployment prerequisites |
| Postcondition | After resource creation | Validate deployed resource |

---

# Key Takeaways

- Preconditions and postconditions are defined inside the **`lifecycle`** block.
- A **precondition** prevents Terraform from creating a resource if a required condition is not met.
- A **postcondition** verifies that the created resource satisfies expected requirements.
- Use the **`self`** object inside postconditions to reference attributes of the current resource.
- These checks improve the reliability, consistency, and safety of Terraform deployments.
