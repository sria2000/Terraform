# Terraform – Dealing with Large Infrastructure

As your infrastructure grows, Terraform has to manage more resources and make more API calls to your cloud provider.

Although cloud providers offer scalable services, **they do not provide unlimited API capacity**. Every provider enforces quotas, rate limits, and service-specific restrictions.

Understanding these limits helps you design Terraform projects that are faster, more reliable, and less likely to hit provider limits.

---

# Why Is This Important?

When Terraform runs commands such as:

```bash
terraform plan
```

or

```bash
terraform apply
```

it communicates with the cloud provider to:

- Read the current infrastructure state
- Compare it with your configuration
- Determine what needs to change
- Create, update, or delete resources

For large infrastructures, this can result in **thousands of API calls**.

---

# Cloud Providers Have Limits

Using AWS, Azure, or GCP does **not** mean you have unlimited resources or unlimited API requests.

Examples include:

- API request rate limits
- Service quotas
- Resource limits
- Regional capacity limits

Some quotas can be increased, while others are fixed.

For example:

- AWS Lambda has certain quotas that cannot be adjusted.
- Some networking services have hard service limits.
- Every cloud provider enforces API rate limiting.

---

# API Throttling

Cloud providers protect their services by limiting how many API requests can be made within a period of time.

For example:

```text
Terraform
      │
      ▼
AWS API
      │
      ▼
Read Resource 1
Read Resource 2
Read Resource 3
...
Read Resource 500
```

If too many requests are sent in a short time, the provider may respond with errors such as:

```text
Rate exceeded

API Throttling

Too Many Requests
```

Terraform may retry some requests, but excessive throttling can significantly slow deployments or cause failures.

---

# Large Terraform Projects

Consider a project containing:

```
terraform-project/

├── networking.tf
├── security.tf
├── compute.tf
├── database.tf
├── storage.tf
├── monitoring.tf
├── iam.tf
├── dns.tf
├── loadbalancer.tf
└── outputs.tf
```

Running:

```bash
terraform plan
```

causes Terraform to evaluate **every resource** in the configuration.

For large environments this can result in:

- Thousands of API calls
- Longer execution times
- Increased chance of API throttling
- Higher load on the cloud provider

---

# Example Configuration

```hcl
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform  = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall"
  description = "Managed from Terraform"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "allow_tls2" {
  name        = "terraform-firewalls"
  description = "Managed from Terraform"
}
```

Even though this example is relatively small, Terraform still performs many API calls to inspect existing resources before creating an execution plan.

---

# Best Practices for Large Infrastructure

## 1. Split Large Projects

Instead of managing hundreds of resources in one directory:

```
terraform-project/
```

split them into smaller projects:

```
terraform/

├── networking/
├── security/
├── compute/
├── databases/
├── monitoring/
└── dns/
```

Benefits:

- Faster planning
- Smaller state files
- Easier troubleshooting
- Fewer API calls
- Better team collaboration

---

## 2. Use Resource Targeting (When Necessary)

If you only need to work on one resource, use resource targeting.

Example:

```bash
terraform plan -target=aws_security_group.allow_tls
```

or

```bash
terraform apply -target=aws_security_group.allow_tls
```

This reduces the number of resources Terraform evaluates.

> **Note:** Resource targeting is intended for exceptional situations and should not be part of your normal workflow.

---

## 3. Disable State Refresh

By default, Terraform refreshes the state before creating a plan.

This means it contacts the cloud provider and reads the current state of every managed resource.

You can skip this refresh by using:

```bash
terraform plan -refresh=false
```

This tells Terraform:

> "Use the existing state file without querying the provider."

Benefits:

- Significantly fewer API calls
- Faster execution
- Useful when you know the infrastructure has not changed outside Terraform

Example:

```bash
terraform plan -refresh=false
```

---

# When to Use `-refresh=false`

Suitable for:

- Large infrastructures
- Local testing
- Reviewing configuration changes
- Reducing unnecessary API calls
- Avoiding temporary API throttling

Avoid using it when:

- Resources may have changed outside Terraform
- Multiple administrators are making changes
- You need the latest infrastructure state
- Running production deployments

---

# Additional Recommendations

- Break large infrastructures into multiple Terraform projects.
- Use modules to organize related resources.
- Keep state files small and focused.
- Avoid running multiple large Terraform operations simultaneously.
- Monitor cloud provider service quotas and request limit increases where possible.
- Review Terraform plans before applying changes.

---

# Summary

| Technique | Benefit |
|-----------|---------|
| Split infrastructure into multiple projects | Smaller state files and fewer API calls |
| Use Terraform modules | Better organization and reuse |
| Use `-target` (exceptionally) | Test or modify a specific resource |
| Use `terraform plan -refresh=false` | Skip state refresh and reduce API calls |
| Monitor provider quotas | Avoid API throttling and deployment failures |

---

# Key Takeaways

- Large Terraform projects generate many cloud API calls.
- Cloud providers enforce API rate limits and service quotas.
- Excessive API requests can lead to throttling and slower deployments.
- Organize infrastructure into smaller Terraform projects whenever possible.
- Use `-target` sparingly for exceptional situations.
- Use `terraform plan -refresh=false` to reduce API calls when you are confident the state file is already up to date.
```
