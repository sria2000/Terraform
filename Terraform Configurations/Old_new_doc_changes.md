# Terraform - AWS Security Group (Old Approach)

This example demonstrates the **older Terraform approach** for creating an AWS Security Group using inline `ingress` and `egress` blocks.

> **Note:** This approach is still supported and widely used in existing Terraform projects. However, HashiCorp recommends using the newer standalone resources:
>
> - `aws_vpc_security_group_ingress_rule`
> - `aws_vpc_security_group_egress_rule`

---

## Documentation Referred

Terraform AWS Provider Documentation

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

---

# File Structure

```text
.
├── old-approach-firewall.tf
└── README.md
```

---

# old-approach-firewall.tf

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "old_approach" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.77.32.50/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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

Create the Security Group

```bash
terraform apply
```

Destroy the resources

```bash
terraform destroy
```

---

# Resource Explanation

## Provider

Configures the AWS provider and specifies the AWS Region.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

## Security Group

Creates an AWS Security Group named **allow_tls**.

```hcl
resource "aws_security_group" "old_approach"
```

---

## Ingress Rule

Allows inbound HTTPS (TCP Port 443) traffic only from:

```text
10.77.32.50/32
```

Configuration:

```hcl
ingress {
  description = "TLS from VPC"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.77.32.50/32"]
}
```

---

## Egress Rule

Allows all outbound traffic.

Configuration:

```hcl
egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
```

Where:

- `-1` = All protocols
- `0.0.0.0/0` = All IPv4 addresses
- `::/0` = All IPv6 addresses

---

# Resources Created

Terraform creates:

- AWS Security Group

The Security Group contains:

- One inline ingress rule
- One inline egress rule

---

# Notes

- This is the **legacy (inline rules)** approach.
- It is still fully supported by Terraform and the AWS Provider.
- Many production environments continue to use this syntax.
- For new projects, HashiCorp recommends defining security group rules as separate resources using:
  - `aws_vpc_security_group_ingress_rule`
  - `aws_vpc_security_group_egress_rule`

---

# Cleanup

To delete the Security Group:

```bash
terraform destroy
```

Confirm by typing:

```text
yes
```

Terraform will remove the Security Group and all associated rules.
