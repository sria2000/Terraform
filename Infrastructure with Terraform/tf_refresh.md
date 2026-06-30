# Terraform Refresh

`terraform refresh` updates the Terraform state file with the latest information from the real infrastructure without making any changes to the actual resources.

> **Note:** In newer versions of Terraform (v1.1+), `terraform refresh` is deprecated. Instead, use `terraform plan` or `terraform apply`, which automatically refresh the state before comparing changes.

---

# Base Code Used

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "PUT-YOUR-ACCESS-KEY-HERE"
  secret_key = "PUT-YOUR-SECRET-KEY-HERE"
}

resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
}
```

> **Best Practice:** Avoid hardcoding AWS access keys and secret keys in Terraform configuration files. Instead, configure credentials using the AWS CLI (`aws configure`), environment variables, or IAM roles.

---

# Commands Used

## Initialize Terraform

```bash
terraform init
```

## Create the EC2 Instance

```bash
terraform apply
```

---

## Manually Modify the Resource

For example, change the EC2 instance type in the AWS Management Console from:

```text
t2.micro
```

to

```text
t2.small
```

At this point:

- **Terraform state:** `t2.micro`
- **Actual AWS resource:** `t2.small`

The Terraform state is out of sync with the real infrastructure.

---

## Refresh the State (Legacy Command)

```bash
terraform refresh
```

Terraform connects to AWS and updates the local `terraform.tfstate` file to match the current infrastructure.

> No infrastructure changes are made—only the state file is updated.

---

## Modern Alternative

Instead of running `terraform refresh`, simply run:

```bash
terraform plan
```

or

```bash
terraform apply
```

Both commands automatically refresh the state before generating the execution plan.

---

# Summary

| Command | Purpose |
|---------|---------|
| `terraform refresh` | Refreshes the Terraform state from the actual infrastructure (deprecated). |
| `terraform plan` | Refreshes the state and shows the changes required to reach the desired state. |
| `terraform apply` | Refreshes the state and applies the required changes. |

---

## Key Points

- `terraform refresh` updates only the **Terraform state file**.
- It **does not create, modify, or destroy** infrastructure.
- Modern Terraform versions automatically refresh the state during `terraform plan` and `terraform apply`, making a separate `terraform refresh` command unnecessary.
