# Terraform Resource Dependencies

Terraform determines the order in which resources are created and destroyed by building a **dependency graph**.

Dependencies can be of two types:

1. **Implicit Dependencies** (Automatically detected by Terraform)
2. **Explicit Dependencies** (Manually defined using `depends_on`)

Understanding these dependency types helps Terraform create and destroy resources in the correct order.

---

# Types of Dependencies

| Dependency Type | Description |
|-----------------|-------------|
| Implicit Dependency | Terraform automatically detects the dependency through resource references. |
| Explicit Dependency | You explicitly tell Terraform about the dependency using `depends_on`. |

---

# Explicit Dependencies

An **explicit dependency** is created using the `depends_on` meta-argument.

Use it when:

- One resource depends on another.
- Terraform cannot automatically determine the dependency.
- Resources have no direct references but still require a specific creation order.

Example:

An EC2 instance stores its application data in an S3 bucket during initialization.

Required order:

```text
Step 1 → Create S3 Bucket

Step 2 → Create EC2 Instance
```

---

## Base Code

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "example" {
  bucket = "kplabs-demo-s3-007"
}
```

Terraform has no knowledge that the EC2 instance should wait for the S3 bucket.

---

## Final Code

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"

  depends_on = [
    aws_s3_bucket.example
  ]
}

resource "aws_s3_bucket" "example" {
  bucket = "kplabs-demo-s3-007"
}
```

Terraform now creates:

```text
S3 Bucket
     │
     ▼
EC2 Instance
```

---

# Resource Deletion Order

Terraform also honours dependencies during resource deletion.

Running:

```bash
terraform destroy -auto-approve
```

Terraform destroys resources in the **reverse order** of creation.

Since the EC2 instance depends on the S3 bucket:

```text
Destroy EC2 Instance
        │
        ▼
Destroy S3 Bucket
```

Creation vs Deletion:

```text
Creation Order

S3 Bucket
     │
     ▼
EC2 Instance


Deletion Order

EC2 Instance
     │
     ▼
S3 Bucket
```

This prevents dependency conflicts during resource removal.

---

# Commands

```bash
terraform apply -auto-approve
```

```bash
terraform destroy -auto-approve
```

---

# Implicit Dependencies

An **implicit dependency** is automatically detected when one resource references an attribute of another resource.

You do **not** need to use `depends_on`.

Terraform builds the dependency graph automatically.

---

# Example Scenario

An EC2 instance should only be created **after** a Security Group is created because the EC2 instance needs the Security Group ID.

Resources:

- EC2 Instance
- Security Group

Required order:

```text
Step 1 → Create Security Group

Step 2 → Create EC2 Instance
```

---

# Base Code

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
}

resource "aws_security_group" "prod" {
  name = "production-sg"
}
```

Terraform sees two independent resources.

It may attempt to create them in parallel.

---

# Final Code

```hcl
resource "aws_instance" "example" {
  ami                    = "ami-0e449927258d45bc4"
  instance_type          = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.prod.id
  ]
}

resource "aws_security_group" "prod" {
  name = "production-sg"
}
```

Notice the reference:

```hcl
aws_security_group.prod.id
```

Terraform automatically understands:

```text
Security Group
      │
      ▼
EC2 Instance
```

No `depends_on` is required.

---

# Resource Creation Flow

```text
Terraform

        │
        ▼

Security Group

        │
        ▼

EC2 Instance
```

Terraform automatically creates the Security Group first because the EC2 instance references its ID.

---

# Resource Deletion Flow

When you run:

```bash
terraform destroy -auto-approve
```

Terraform again uses the dependency graph.

Deletion order becomes:

```text
EC2 Instance

      │
      ▼

Security Group
```

Terraform first removes the EC2 instance and then deletes the Security Group.

---

# Commands

Create resources:

```bash
terraform apply -auto-approve
```

Destroy resources:

```bash
terraform destroy -auto-approve
```

---

# Implicit vs Explicit Dependencies

| Feature | Implicit Dependency | Explicit Dependency |
|---------|----------------------|---------------------|
| Defined by | Resource references | `depends_on` |
| Automatic | Yes | No |
| Requires manual configuration | No | Yes |
| Recommended | Yes | Only when Terraform cannot detect the dependency |

---

# Best Practices

- Prefer **implicit dependencies** whenever possible.
- Use `depends_on` only when Terraform cannot infer the relationship.
- Avoid unnecessary explicit dependencies, as they reduce Terraform's ability to create resources in parallel.
- Always review `terraform plan` to verify the dependency graph before applying changes.

---

# Key Takeaways

- Terraform builds a dependency graph to determine resource order.
- **Implicit dependencies** are automatically detected through resource references.
- **Explicit dependencies** are created manually using `depends_on`.
- Resources are destroyed in the **reverse order** of their dependencies.
- Prefer implicit dependencies for cleaner and more maintainable Terraform code.
