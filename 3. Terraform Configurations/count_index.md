Count Index Argument

## Will have different names as tags based on index

resource "aws_instance" "myec2" { 
     ami = "ami-00c39f71452c08778" 
	 instance_type = "t2.micro" 
	 count = 30 
	 
	 tags = { 
	   Name = "Development-Server-${count.index}" } 
	  }
}

## Will create 
Development-Server-0 to Development-Server-29

## For IAM Users
# AWS IAMUser 

resource "aws_iam_user" "lb" {
    name = "sriram-${count.index}" 
	count = 3 
	}
# 3 users - sriram0 / sriram1 / sriram2 will be created

## Create a better code using variables



variable "users" {
   type = list
   default = ["sri","ram","Krish"]
  }
  
 resource "aws_iam_user" "lb" {
    name = var.users[count.index]
	count = 3 
	} 

## Creates users - Sri / Ram / Krish using variables
