# Terraform Notes

## Terraform to Create a New EC2 Instance

```hcl
provider "aws" {
  region     = "eu-west-1"
  access_key = "PUT-YOUR-ACCESS-KEY-HERE"
  secret_key = "PUT-YOUR-SECRET-KEY-HERE"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0049736975ba478c0"
  instance_type = "t3.micro"

  tags = {
    Name = "my-first-ec2-sri"
  }
}
```

## Azure Provider

```hcl
provider "azurerm" {
  features {}
}
```

## Useful Links

- https://registry.terraform.io/
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Terraform Commands

```bash
terraform init
terraform plan
terraform apply
```
