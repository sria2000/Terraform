# Terraform Data Sources

## Introduction

Terraform **Data Sources** allow Terraform to **fetch or read information that already exists outside of the current Terraform configuration**.

Data sources are commonly used to retrieve information about existing infrastructure without creating or managing it.

Examples include:

- Existing EC2 instances
- Existing AMIs
- Existing VPCs
- Existing Security Groups
- Cloud account information
- Local files

---

# Documentation

## DigitalOcean Account Data Source

https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/account

## AWS Instance Data Source

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance

## AWS AMI Data Source

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

---

# Data Source Format

A data source is accessed using a special type of resource called a **data resource**, which is declared using the `data` block.

General syntax:

```hcl
data "<provider>_<resource>" "<name>" {

}
```

Examples:

```hcl
data "aws_instance" "foo" {

}
```

```hcl
data "digitalocean_account" "example" {

}
```

---

# Example 1: Fetch DigitalOcean Account Information

**File:** `data-source-01.tf`

```hcl
terraform {

  required_providers {

    digitalocean = {
      source = "digitalocean/digitalocean"
    }

  }

}

provider "digitalocean" {

  token = "your-token-here"

}

data "digitalocean_account" "example" {

}
```

### Explanation

- Connects to the DigitalOcean provider.
- Retrieves account information.
- No resources are created.

After running:

```bash
terraform apply
```

Check the **terraform.tfstate** file to view the retrieved account details.

---

# Example 2: Read a Local File

**File:** `data-source-02.tf`

```hcl
data "local_file" "foo" {

  filename = "${path.module}/demo.txt"

}

output "data" {

  value = data.local_file.foo.content

}
```

### Example

Suppose **demo.txt** contains:

```
hello from Sri
```

Run:

```bash
terraform apply
```

Output:

```
data = "hello from Sri"
```

The contents of the file are also stored in the **terraform.tfstate** file.

---

# Example 3: Fetch Existing EC2 Instances

**File:** `data-source-03.tf`

```hcl
provider "aws" {

  region = "us-east-1"

}

data "aws_instances" "example" {

}
```

### Explanation

This data source retrieves information about existing EC2 instances in the AWS account.

No new EC2 instances are created.

---

# Example 4: Fetch an EC2 Instance Using Filters

**File:** `data-source-format.tf`

```hcl
provider "aws" {

  region = "us-east-1"

}

data "aws_instance" "example" {

  filter {

    name = "tag:Team"

    values = ["Production"]

  }

}
```

### Explanation

Terraform searches for an EC2 instance that has the tag:

```
Team = Production
```

After running Terraform, inspect the **terraform.tfstate** file to see the retrieved instance details.

---

# Example 5: Fetch the Latest Ubuntu AMI

Hardcoding an AMI ID is **not recommended** because:

- AMI IDs differ between AWS regions.
- New AMIs are released regularly.
- Old AMIs may become outdated.

Instead, use a data source to retrieve the latest AMI.

---

## Base Code

```hcl
provider "aws" {

  region = "us-east-1"

}

resource "aws_instance" "web" {

  ami = ""

  instance_type = "t2.micro"

}
```

---

## Final Code

```hcl
provider "aws" {

  region = "ap-south-1"

}

data "aws_ami" "myimage" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    ]

  }

}

resource "aws_instance" "web" {

  ami = data.aws_ami.myimage.image_id

  instance_type = "t2.micro"

}
```

### Explanation

Terraform:

1. Searches for Ubuntu 22.04 AMIs published by Amazon.
2. Finds the most recent image.
3. Uses its AMI ID to launch the EC2 instance.

Instead of:

```hcl
ami = "ami-xxxxxxxx"
```

Terraform uses:

```hcl
ami = data.aws_ami.myimage.image_id
```

This ensures the latest image is always used.

---

# Data Source Reference Syntax

General syntax:

```hcl
data.<TYPE>.<NAME>.<ATTRIBUTE>
```

Examples:

```hcl
data.local_file.foo.content
```

```hcl
data.aws_ami.myimage.image_id
```

```hcl
data.aws_instance.example.id
```

---

# Resource vs Data Source

| Resource | Data Source |
|----------|-------------|
| Creates infrastructure | Reads existing infrastructure |
| Uses `resource` block | Uses `data` block |
| Managed by Terraform | Not managed by Terraform |
| Changes infrastructure | Only fetches information |
| Example: Create EC2 | Example: Read existing EC2 |

---

# Common AWS Data Sources

| Data Source | Purpose |
|-------------|---------|
| `aws_ami` | Fetch AMIs |
| `aws_instance` | Fetch an EC2 instance |
| `aws_instances` | Fetch multiple EC2 instances |
| `aws_vpc` | Fetch an existing VPC |
| `aws_subnet` | Fetch an existing subnet |
| `aws_security_group` | Fetch an existing security group |
| `aws_caller_identity` | Get AWS account information |
| `aws_region` | Get current AWS region |

---

# Benefits of Data Sources

- Avoid hardcoding values.
- Read existing cloud resources.
- Improve portability across environments.
- Automatically retrieve the latest resource information.
- Reuse existing infrastructure.
- Reduce maintenance effort.

---

# Key Interview Points

- **Data sources read existing infrastructure; they do not create resources.**
- **Data sources are declared using the `data` block.**
- **Data source attributes are accessed using:**

```hcl
data.<type>.<name>.<attribute>
```

- **Using data sources avoids hardcoding values such as AMI IDs, VPC IDs, and Security Group IDs.**
