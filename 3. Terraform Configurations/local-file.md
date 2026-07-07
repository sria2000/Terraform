# Terraform Local Values

## Use of Variables

# Local Values

Local values are similar to variables because they allow you to store data centrally and reference it in multiple parts of the Terraform configuration.

Local values help to avoid repeating the same values throughout Terraform files.

---

# Documentation

Terraform Format Date Function:

https://developer.hashicorp.com/terraform/language/functions/formatdate

Terraform Local Values Documentation:

https://developer.hashicorp.com/terraform/language/values/locals

---

# Base Code: local-values.tf

```hcl
resource "aws_security_group" "sg_01" {

  name = "app_firewall"

  tags = {
    Name = "security-team"
  }

}


resource "aws_security_group" "sg_02" {

  name = "db_firewall"

  tags = {
    Name = "security-team"
  }

}
