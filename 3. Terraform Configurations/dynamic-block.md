# Terraform Dynamic Blocks

## Why Use Dynamic Blocks?

Dynamic Blocks help keep your Terraform code:

- **DRY (Don't Repeat Yourself)**
- Easier to maintain
- More scalable
- Less error-prone

Instead of copying and pasting multiple nested blocks (such as `ingress`, `egress`, `setting`, etc.), you can generate them dynamically using a loop.

---

## When to Use Dynamic Blocks

Use Dynamic Blocks when you have multiple nested blocks with similar configurations.

### Example

Instead of writing multiple `ingress` rules manually:

- Port 8200
- Port 8201
- Port 8300
- Port 9200
- Port 9500

Create a list of ports and let Terraform generate the blocks automatically.

---

## Documentation

https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks

---

# Base Code (Without Dynamic Blocks)

```hcl
resource "aws_security_group" "demo_sg" {
  name = "sample-sg"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9500
    to_port     = 9500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

This works, but it repeats the same code multiple times.

---

# Generic Dynamic Block Syntax

Terraform documentation provides the following syntax:

```hcl
dynamic "setting" {
  for_each = var.settings

  content {
    namespace = setting.value["namespace"]
    name      = setting.value["name"]
    value     = setting.value["value"]
  }
}
```

### Explanation

- `dynamic` → Creates repeated nested blocks.
- `"setting"` → Name of the block to generate.
- `for_each` → Loops through a collection.
- `content` → Defines the contents of each generated block.

---

# Step 1 - Store the Ports in a List

```hcl
variable "sg_ports" {
  type    = list(number)
  default = [8200, 8201, 8300, 9200, 9500]
}
```

---

# Step 2 - Create the Dynamic Block

```hcl
resource "aws_security_group" "demo_sg" {
  name = "sample-sg"

  dynamic "ingress" {

    for_each = var.sg_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

Terraform automatically generates one `ingress` block for each port in the list.

---

# Generated Configuration

Terraform internally creates something similar to:

```hcl
ingress {
  from_port   = 8200
  to_port     = 8200
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 8201
  to_port     = 8201
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 8300
  to_port     = 8300
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 9200
  to_port     = 9200
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 9500
  to_port     = 9500
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

You only write the code once, while Terraform generates all the required blocks.

---

# Commands

## View the Execution Plan

```bash
terraform plan
```

## Create the Resources

```bash
terraform apply -auto-approve
```

## Destroy the Resources

```bash
terraform destroy -auto-approve
```

---

# Advantages of Dynamic Blocks

- Eliminates repetitive code.
- Makes Terraform configuration cleaner.
- Easier to add or remove ports.
- Improves readability.
- Follows the **DRY (Don't Repeat Yourself)** principle.
- Makes configurations easier to maintain.

---

# Key Points

- Dynamic Blocks generate repeated nested blocks.
- Use `for_each` to iterate over a list, map, or set.
- `content` defines what each generated block should contain.
- `ingress.value` represents the current item in the loop.
- Commonly used with:
  - Security Groups (`ingress` / `egress`)
  - IAM Policies
  - Elastic Beanstalk settings
  - Route tables
  - Load balancer listener rules
  - Any repeated nested configuration

> **Exam Tip (Terraform Associate):** Know the difference between **`for_each` on resources** and **`dynamic` blocks**. `for_each` creates multiple resources, whereas a `dynamic` block creates multiple nested blocks within a single resource.
