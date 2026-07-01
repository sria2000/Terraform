# Terraform - Create an AWS EC2 Instance with a Security Group

This project demonstrates how to use **Terraform** to:

- Create an AWS EC2 instance
- Create a Security Group (Firewall)
- Allow inbound HTTP (Port 80)
- Allow all outbound traffic
- Attach the Security Group to the EC2 instance
- Install and run Nginx

---

## Documentation Referred

Terraform AWS Provider Documentation:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

---

# Project Structure

```text
.
├── firewall.tf
└── README.md
```

---

# firewall.tf

```hcl
provider "aws" {

}

# Security Group
resource "aws_security_group" "allow_http" {
  name        = "terraform-firewall"
  description = "Allow HTTP traffic"
}

# Inbound Rule - HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

# Outbound Rule - Allow All
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_http.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# EC2 Instance
resource "aws_instance" "myec2" {
  ami           = "ami-0049736975ba478c0"
  instance_type = "t3.micro"

  # Attach Security Group
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "my-first-ec2-sri"
  }
}
```

---

# Terraform Commands

Initialize Terraform

```bash
terraform init
```

Review the execution plan

```bash
terraform plan
```

Create the infrastructure

```bash
terraform apply
```

Destroy all resources

```bash
terraform destroy
```

---

# Connect to the EC2 Instance

SSH into the instance using its Public IP address.

```bash
ssh -i <private-key>.pem ec2-user@<Public-IP>
```

For Ubuntu AMIs:

```bash
ssh -i <private-key>.pem ubuntu@<Public-IP>
```

---

# Install Nginx

Update the operating system

```bash
sudo yum update -y
```

Install Nginx

```bash
sudo yum install nginx -y
```

Enable Nginx to start automatically

```bash
sudo systemctl enable nginx
```

Start the Nginx service

```bash
sudo systemctl start nginx
```

Verify that Nginx is running

```bash
sudo systemctl status nginx
```

---

# Verify the Web Server

Open a web browser and navigate to:

```text
http://<Public-IP>
```

You should see the default **Welcome to nginx!** page.

---

# Resources Created

Terraform creates the following AWS resources:

- EC2 Instance (`aws_instance`)
- Security Group (`aws_security_group`)
- Security Group Ingress Rule (`aws_vpc_security_group_ingress_rule`)
- Security Group Egress Rule (`aws_vpc_security_group_egress_rule`)

---

# Notes

- Port **80** is open to allow HTTP traffic.
- All outbound traffic is permitted.
- The Security Group is attached to the EC2 instance using:

```hcl
vpc_security_group_ids = [aws_security_group.allow_http.id]
```

- If you need SSH access, create an additional ingress rule allowing TCP port **22** from your public IP address.

---

# Cleanup

To remove all resources created by Terraform:

```bash
terraform destroy
```

Confirm the action by typing:

```text
yes
```

Terraform will delete the EC2 instance, Security Group, and associated resources.
