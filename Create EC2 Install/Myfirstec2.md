## Terraform to create a new EC2 instance

provider "aws" {
   region = "er=west-1"
   access_key = "PUT-YOUR-ACCESS-KEY-HERE"
   secret_key = "PUT-YOUR-SECRET-KEY-HERE"
}

resource "aws_instance" "myec2" {
    ami = "ami-0049736975ba478c0"
    instance_type = "t3.micro"

    tags = {
        Name = "my-first-ec2-sri"
    }
}

# Run this to create a plugin for azure
provider azurerm {}

## LINKS 
https://registry.terraform.io/

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## COMMANDS:
terraform init
terraform plan
terraform apply
