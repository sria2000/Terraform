provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "myec2" {
    ami = "ami-0d0463f1527996442"
    instance_type = "t2.micro"
}
