# Terraform to create a new EC2 instance

provider "aws" {
   region = "er=west-1"
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
