# Configure the AWS Provider

Before using the AWS provider, install and configure the AWS CLI with your AWS credentials.

## AWS CLI Documentation

AWS provides installation instructions for all supported operating systems:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

---

# Example: `aws-provider-config.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "demouser" {
  name = "sri-demo-user"
}
```

---

# Configure AWS CLI

Run the following command to configure your AWS credentials:

```bash
aws configure
```

You will be prompted to enter:

- AWS Access Key ID
- AWS Secret Access Key
- Default region (for example, `us-east-1`)
- Default output format (optional, e.g., `json`)

---

# Terraform Commands

## Create the Resources

```bash
terraform apply -auto-approve
```

> The `-auto-approve` option skips the interactive approval prompt.

---

## Destroy the Resources

```bash
terraform destroy -auto-approve
```

> This removes all resources managed by the current Terraform configuration without asking for confirmation.

---

# Workflow

1. Install the AWS CLI.
2. Configure AWS credentials using `aws configure`.
3. Create your Terraform configuration.
4. Initialize Terraform:

```bash
terraform init
```

5. Review the execution plan:

```bash
terraform plan
```

6. Create the infrastructure:

```bash
terraform apply -auto-approve
```

7. Destroy the infrastructure when no longer needed:

```bash
terraform destroy -auto-approve
```
