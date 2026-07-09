# Terraform Meta Argument - Lifecycle

The `lifecycle` meta-argument controls how Terraform manages the **creation, update, and deletion behaviour** of resources.

The `lifecycle` block is part of Terraform's built-in functionality and is not specific to any cloud provider.

Example:

```hcl
resource "aws_instance" "myec2" {

  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }

}
```

---

# Lifecycle Meta-Arguments

Terraform supports four lifecycle arguments:

| Lifecycle Argument | Purpose |
|--------------------|---------|
| `create_before_destroy` | Create replacement resource before destroying old resource |
| `prevent_destroy` | Prevent accidental deletion of resources |
| `ignore_changes` | Ignore changes made to selected attributes |
| `replace_triggered_by` | Force resource replacement when another resource changes |

---

# 1. create_before_destroy

## Purpose

By default, Terraform follows:

```
Destroy Existing Resource
          |
          ▼
Create New Resource
```

This can cause downtime.

`create_before_destroy = true` changes the behaviour:

```
Create New Resource
          |
          ▼
Destroy Old Resource
```

This helps reduce service interruption.

---

# Example Scenario

You have an EC2 instance:

```hcl
ami = "ami-old"
```

Later you update:

```hcl
ami = "ami-new"
```

Changing the AMI requires a replacement because an existing EC2 instance cannot change its operating system image.

---

## Default Behaviour

Terraform:

```
Destroy old EC2
        |
        ▼
Create new EC2
```

Possible downtime.

---

## With create_before_destroy

Terraform:

```
Create new EC2 using new AMI
        |
        ▼
Destroy old EC2
```

Reduced downtime.

---

# Base Code

`create-before-destroy.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }
}
```

---

# Final Code

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }

    lifecycle {

      create_before_destroy = true

    }
}
```

---

# 2. prevent_destroy

## Purpose

`prevent_destroy` protects important resources from accidental deletion.

Common examples:

- Production databases
- Critical storage resources
- Important infrastructure components

Terraform will refuse to destroy resources with this lifecycle rule enabled.

---

# Important Note

The lifecycle rule must exist in the Terraform configuration.

If you remove the resource block completely from the `.tf` file, Terraform cannot apply the protection because the configuration no longer exists.

---

# Base Code

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }
}
```

---

# Final Code

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }

    lifecycle {

      prevent_destroy = true

    }
}
```

---

# Example

Running:

```bash
terraform destroy
```

Terraform will stop:

```text
Error: Instance cannot be destroyed
```

because:

```hcl
prevent_destroy = true
```

is enabled.

---

# 3. ignore_changes

## Purpose

`ignore_changes` tells Terraform to ignore modifications made to selected resource attributes outside Terraform.

Useful when:

- Another team manages specific attributes.
- Cloud automation modifies values.
- Manual changes are expected.

---

# Example Problem

Terraform configuration:

```hcl
tags = {
  Name = "HelloEarth"
}
```

Someone manually changes in AWS:

```hcl
tags = {
  Name = "HelloWorld"
}
```

Normally Terraform detects the difference:

```
HelloWorld → HelloEarth
```

and tries to revert it.

Using `ignore_changes` prevents this.

---

# Ignore Specific Attributes

Example:

```hcl
lifecycle {

  ignore_changes = [
    tags,
    instance_type
  ]

}
```

Terraform ignores only:

- tags
- instance_type

---

# Base Code

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }

}
```

---

# Ignore Selected Attributes

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloWorld"
    }

    lifecycle {

      ignore_changes = [
        tags,
        instance_type
      ]

    }

}
```

---

# Ignore All Changes

Terraform also supports:

```hcl
lifecycle {

  ignore_changes = all

}
```

Example:

```hcl
resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"

    instance_type = "t2.micro"

    tags = {
        Name = "HelloWorld"
    }

    lifecycle {

      ignore_changes = all

    }

}
```

Terraform will ignore changes to every attribute.

---

# 4. replace_triggered_by

## Purpose

`replace_triggered_by` forces Terraform to replace a resource when another resource changes.

Example:

```hcl
lifecycle {

  replace_triggered_by = [
    aws_security_group.example.id
  ]

}
```

If the security group changes, Terraform replaces the dependent resource.

---

# Lifecycle Summary

| Argument | Behaviour |
|----------|-----------|
| `create_before_destroy` | Create replacement before destroying old resource |
| `prevent_destroy` | Block accidental deletion |
| `ignore_changes` | Ignore changes to selected attributes |
| `replace_triggered_by` | Replace resource when another resource changes |

---

# Challenges with count Meta-Argument

The `count` meta-argument creates multiple instances of a resource.

Example:

```hcl
variable "iam_names" {

  type = list

  default = [
    "user-01",
    "user-02",
    "user-03"
  ]

}


resource "aws_iam_user" "iam" {

  name = var.iam_names[count.index]

  count = 3

  path = "/system/"

}
```

---

# Execution

Run:

```bash
terraform init
```

```bash
terraform plan
```

Terraform creates:

```
aws_iam_user.iam[0]  → user-01

aws_iam_user.iam[1]  → user-02

aws_iam_user.iam[2]  → user-03
```

Terraform state:

```
0th position = user-01
1st position = user-02
2nd position = user-03
```

---

# Problem with count

`count` depends on list position.

Example:

Original:

```hcl
default = [
 "user-01",
 "user-02",
 "user-03"
]
```

State:

```
0 → user-01
1 → user-02
2 → user-03
```

---

Now add a new user at the beginning:

```hcl
default = [
 "user-00",
 "user-01",
 "user-02",
 "user-03"
]
```

New mapping:

```
0 → user-00
1 → user-01
2 → user-02
3 → user-03
```

Terraform sees:

```
user-01 changed to user-00
user-02 changed to user-01
user-03 changed to user-02
```

This can cause:

- Resource updates
- Resource deletion
- Resource recreation

The result can become difficult to manage.

---

# Better Approach With count

If using `count`, add new items at the end.

Example:

```hcl
default = [
 "user-01",
 "user-02",
 "user-03",
 "user-04"
]

count = 4
```

Result:

```
0 → user-01
1 → user-02
2 → user-03
3 → user-04
```

Existing resources remain unchanged.

---

# Best Practice

For resources requiring stable identities:

Prefer:

```hcl
for_each
```

instead of:

```hcl
count
```

because `for_each` uses keys instead of list positions.

Example:

```hcl
for_each = toset([
 "user-01",
 "user-02",
 "user-03"
])
```

Adding a new user does not shift existing indexes.

---

# Key Takeaways

- Lifecycle controls Terraform resource behaviour.
- `create_before_destroy` helps reduce downtime.
- `prevent_destroy` protects critical resources.
- `ignore_changes` prevents Terraform from reverting external changes.
- `replace_triggered_by` forces replacement based on another resource.
- `count` can cause unwanted changes when list order changes.
- Use `for_each` when resource identity needs to remain stable.
