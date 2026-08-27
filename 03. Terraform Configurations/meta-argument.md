# Terraform Resource Behaviour and Meta-Arguments

Terraform uses a **declarative approach** to manage infrastructure.

You describe the **desired state** in Terraform configuration files (`.tf` files), and Terraform compares it with the **current state** stored in the Terraform state file.

Terraform then determines what actions are required to make the real infrastructure match the configuration.

---

# Terraform Resource Behaviour

When Terraform runs:

```bash
terraform plan
```

Terraform performs the following steps:

1. Reads the Terraform configuration files.
2. Reads the Terraform state file.
3. Queries the remote infrastructure (AWS, Azure, GCP, etc.).
4. Creates an execution plan.
5. Determines what resources need to be created, updated, or destroyed.

---

# How Terraform Applies Configuration

Terraform manages resources using four main behaviours:

---

# 1. Creates Resources That Exist in Configuration but Not in State

If a resource exists in the Terraform configuration but is not present in the state file, Terraform creates it.

Example:

Terraform configuration:

```hcl
resource "aws_instance" "myec2" {

  ami           = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"

}
```

State:

```text
No aws_instance.myec2 found
```

Terraform action:

```text
+ Create aws_instance.myec2
```

---

# 2. Deletes Resources That Exist in State but No Longer Exist in Configuration

Terraform tracks resources using the state file.

If a resource exists in the state but has been removed from the Terraform configuration, Terraform assumes it should no longer exist.

Example:

Terraform state:

```text
aws_instance.myec2
```

Configuration:

```text
Resource removed
```

Terraform action:

```text
- Destroy aws_instance.myec2
```

---

# 3. Updates Resources In-Place When Arguments Change

Some resource changes can be updated without destroying the resource.

Example:

Before:

```hcl
tags = {
  Name = "OldName"
}
```

After:

```hcl
tags = {
  Name = "NewName"
}
```

Terraform action:

```text
~ Update in-place
```

The existing resource remains and only the changed attribute is modified.

---

# 4. Destroy and Recreate Resources When Updates Are Not Supported

Some changes cannot be performed on an existing resource because of remote API limitations.

Terraform must:

1. Destroy the existing resource.
2. Create a new resource with the updated configuration.

Example:

Changing an EC2 operating system:

Before:

```text
Windows AMI
```

After:

```text
Linux AMI
```

Terraform cannot convert a running Windows instance into Linux.

Terraform action:

```text
-/+ Destroy and recreate
```

Process:

```text
Destroy Windows EC2
        |
        ▼
Create Linux EC2
```

---

# Terraform Default Behaviour

Terraform follows the principle:

> Configuration is the source of truth.

Terraform always tries to make the real infrastructure match the Terraform code.

---

# Example Problem

Terraform configuration:

```text
EC2 Instance 1
EC2 Instance 2
```

AWS Console:

```text
EC2 Instance 1
EC2 Instance 2
EC2 Instance 3 (manually created)
```

Terraform state:

```text
EC2 Instance 1
EC2 Instance 2
```

When running:

```bash
terraform apply
```

Terraform sees:

```
AWS has an unmanaged EC2 instance
```

Terraform may remove resources that are not defined in the configuration.

---

# Solution: lifecycle Meta-Argument

If you want Terraform to ignore certain external changes, use:

```hcl
lifecycle {
  ignore_changes = []
}
```

Example:

```hcl
resource "aws_instance" "myec2" {

    ami = "ami-0f34c5ae932e6f0e4"
    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }

    lifecycle {
        ignore_changes = [tags]
    }
}
```

Terraform will ignore changes made to tags outside Terraform.

---

# Terraform Meta-Arguments

Meta-arguments are special Terraform arguments that control **resource behaviour**.

They are not specific to any provider.

They are built into Terraform itself.

---

# Common Meta-Arguments

Terraform supports the following resource meta-arguments:

| Meta Argument | Purpose |
|---------------|---------|
| `depends_on` | Explicitly defines resource dependencies |
| `count` | Creates multiple instances of a resource |
| `for_each` | Creates multiple resources using a map or set |
| `lifecycle` | Controls resource creation, update, and deletion behaviour |
| `provider` | Selects which provider configuration to use |

---

# 1. depends_on

`depends_on` creates an explicit dependency between resources.

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    aws_security_group.web
  ]

}
```

Terraform creates:

```text
Security Group
       |
       ▼
EC2 Instance
```

Use when Terraform cannot automatically detect dependencies.

---

# 2. count

`count` creates multiple copies of a resource.

Example:

```hcl
resource "aws_instance" "server" {

  count = 3

  ami = "ami-xxxx"
  instance_type = "t2.micro"

}
```

Creates:

```text
aws_instance.server[0]

aws_instance.server[1]

aws_instance.server[2]
```

---

# 3. for_each

`for_each` creates multiple resources from a map or set.

Example:

```hcl
resource "aws_iam_user" "users" {

  for_each = toset([
    "user1",
    "user2",
    "user3"
  ])

  name = each.value

}
```

Creates:

```text
user1
user2
user3
```

---

# 4. lifecycle

The lifecycle block controls how Terraform manages resource changes.

Common lifecycle options:

| Option | Purpose |
|--------|---------|
| `create_before_destroy` | Creates replacement before destroying old resource |
| `prevent_destroy` | Prevents accidental deletion |
| `ignore_changes` | Ignores changes to selected attributes |

---

## lifecycle Example

### Base Code

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

### Final Code

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
        ignore_changes = [tags]
    }
}
```

---

# 5. provider

The `provider` meta-argument selects which provider configuration should manage the resource.

Example:

```hcl
resource "aws_instance" "example" {

  provider = aws.us_east

  ami = "ami-xxxx"

}
```

Useful when managing:

- Multiple AWS regions
- Multiple cloud accounts
- Multiple provider configurations

---

# Resource Lifecycle Flow

Terraform resource lifecycle:

```
Configuration
      |
      ▼
Terraform Plan
      |
      ▼
Compare State
      |
      ▼
Create / Update / Destroy
      |
      ▼
Remote Infrastructure
```

---

# Best Practices

- Treat Terraform configuration as the source of truth.
- Avoid manually changing resources outside Terraform.
- Use `ignore_changes` carefully.
- Use `prevent_destroy` for critical resources.
- Use `depends_on` only when Terraform cannot detect dependencies automatically.
- Prefer `for_each` over `count` when managing named resources.
- Review `terraform plan` before applying changes.

---

# Summary

| Behaviour | Terraform Action |
|-----------|------------------|
| Resource in config but missing in state | Create resource |
| Resource in state but removed from config | Destroy resource |
| Argument changed and update supported | Update in-place |
| Argument changed and update unsupported | Destroy and recreate |

---

# Key Takeaway

Terraform continuously tries to make:

```
Terraform Configuration
          =
Real Infrastructure
```

Meta-arguments provide additional control over **how Terraform creates, updates, and manages resources**.
