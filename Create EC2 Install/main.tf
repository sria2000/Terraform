provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2023 x86_64 (us-east-1)
    instance_type = "t3.micro"
}