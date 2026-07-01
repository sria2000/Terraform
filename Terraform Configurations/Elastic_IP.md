# Terraform - Create an AWS Elastic IP (EIP)

This example demonstrates how to use **Terraform** to create an **AWS Elastic IP (EIP)**.

An **Elastic IP (EIP)** is a static public IPv4 address that can be associated with an EC2 instance or other supported AWS resources. Unlike a standard public IP, an Elastic IP remains allocated to your AWS account until you release it.

---

## Documentation Referred

Terraform AWS Provider Documentation

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

---

# File Structure

```text
.
├── eip.tf
└── README.md
```

---

# eip.tf

```hcl
resource "aws_eip" "lb" {
  domain = "vpc"
}
```

---

# Resource Explanation

## Elastic IP

Creates an Elastic IP address for use within a VPC.

```hcl
resource "aws_eip" "lb" {
  domain = "vpc"
}
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `domain` | Specifies that the Elastic IP is allocated for use in a VPC. |

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

Create the Elastic IP

```bash
terraform apply -auto-approve
```

Destroy the Elastic IP

```bash
terraform destroy -auto-approve
```

---

# Resources Created

Terraform creates:

- One AWS Elastic IP (`aws_eip`)

---

# Verify the Elastic IP

After applying the configuration, verify the Elastic IP by:

1. Sign in to the AWS Management Console.
2. Navigate to **VPC** → **Elastic IPs**.
3. Confirm that the new Elastic IP has been allocated.

Alternatively, run:

```bash
terraform state list
```

---

# Notes

- An Elastic IP is a **static public IPv4 address**.
- It can be associated with an EC2 instance, NAT Gateway, or other supported AWS resources.
- If an Elastic IP is allocated but not associated with a running resource, AWS may charge for it.
- Always release unused Elastic IPs to avoid unnecessary costs.

---

# Cleanup

To remove the Elastic IP:

```bash
terraform destroy -auto-approve
```

Terraform will release the allocated Elastic IP from your AWS account.
