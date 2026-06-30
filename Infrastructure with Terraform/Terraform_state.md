# Terraform State

Terraform uses a **state file** to keep track of the infrastructure it manages. By default, the state is stored locally in a file named `terraform.tfstate`.

The state file maps the resources defined in your Terraform configuration to the real infrastructure created in your cloud provider.

---

# Base Code Used

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t2.micro"
}
```

---

# Commands Used

## Create the Resource

```bash
terraform apply
```

## Destroy the Resource

```bash
terraform destroy
```

---

# Common Terraform State Commands

## List all resources in the state

```bash
terraform state list
```

## Show detailed information about a resource

```bash
terraform state show aws_instance.myec2
```

## Remove a resource from the state (without destroying it)

```bash
terraform state rm aws_instance.myec2
```

> **Note:** This removes the resource only from the Terraform state. The actual AWS resource continues to exist.

## Move or rename a resource in the state

```bash
terraform state mv SOURCE DESTINATION
```

Example:

```bash
terraform state mv aws_instance.myec2 aws_instance.webserver
```

---

# Terraform State File

After running `terraform apply`, Terraform creates:

```text
terraform.tfstate
```

This file contains information such as:

- Resource IDs
- Resource attributes
- Resource dependencies
- Metadata used by Terraform to manage infrastructure

> **Important:** Do not edit the `terraform.tfstate` file manually. Any changes should be made using Terraform commands.
