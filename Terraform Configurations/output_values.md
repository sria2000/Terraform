# Terraform - Output Values

This document explains **Terraform Output Values**, how they are used, and different ways to customize output.

---

# What are Output Values?

Output values are used to **display information after Terraform applies infrastructure changes**.

They are useful for:
- Showing EC2 public IPs
- Displaying Load Balancer URLs
- Exporting values to other modules
- Debugging infrastructure

---

# File: output-values.tf

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "lb" {
  domain = "vpc"
}

output "public-ip" {
  value = aws_eip.lb.public_ip
}
```

---

# Terraform Commands Used

```bash
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

# Output Example (Simple Value)

When using:

```hcl
output "public_ip" {
  value = aws_eip.lb.public_ip
}
```

### Output:

```text
Outputs:

public_ip = "52.211.187.248"
```

---

# Output Customization Examples

## 1. Basic Output (Public IP)

```hcl
output "public-ip" {
  value = aws_eip.lb.public_ip
}
```

Returns:
- Only the Elastic IP address

---

## 2. Formatted Output (URL Example)

```hcl
output "public-ip" {
  value = "https://${aws_eip.lb.public_ip}:8080"
}
```

### Output:
```text
public_ip = "https://52.211.187.248:8080"
```

---

## 3. Full Resource Output

```hcl
output "public-ip" {
  value = aws_eip.lb
}
```

### Output (Full Object):

```text
Outputs:

public_ip = {
  "address" = tostring(null)
  "allocation_id" = "eipalloc-0f1649ba2d167974b"
  "arn" = "arn:aws:ec2:eu-west-1:607073961626:elastic-ip/eipalloc-0f1649ba2d167974b"
  "association_id" = ""
  "domain" = "vpc"
  "id" = "eipalloc-0f1649ba2d167974b"
  "public_dns" = "ec2-52-211-187-248.eu-west-1.compute.amazonaws.com"
  "public_ip" = "52.211.187.248"
  "region" = "eu-west-1"
}
```

---

# Key Differences

| Output Type | Result |
|-------------|--------|
| `aws_eip.lb.public_ip` | Only IP address |
| `"https://${aws_eip.lb.public_ip}:8080"` | Custom formatted string |
| `aws_eip.lb` | Full resource object |

---

# Why Use Output Values?

- Display important infrastructure details
- Share values between modules
- Automate CI/CD pipelines
- Avoid manually checking AWS console

---

# CLI Commands Used

```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

---

# Key Takeaways

- Outputs expose Terraform values after deployment
- You can output:
  - Single attributes
  - Formatted strings
  - Entire resource objects
- Useful for automation and visibility

---
