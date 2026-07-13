# Terraform Workspaces

## Overview

Terraform **Workspaces** allow you to manage **multiple state files** from the **same Terraform configuration**.

Instead of maintaining separate Terraform folders for Development, Testing, and Production, workspaces enable multiple independent deployments using a single set of Terraform code.

Each workspace maintains its **own Terraform state file**, allowing environments to remain completely isolated.

---

# Why Use Workspaces?

Consider the following questions:

- What if there are multiple state files for a single Terraform configuration?
- Can we manage different environments separately?

The answer is **Terraform Workspaces**.

Example:

```
Terraform Configuration
        │
        ├── State File (Development)
        ├── State File (Testing)
        └── State File (Production)
```

Each workspace has its own independent state.

---

# Benefits of Workspaces

- Multiple environments from the same code
- Separate Terraform state files
- Easy switching between environments
- Avoid maintaining duplicate Terraform projects
- Simplifies Development, Test and Production deployments

---

# How Workspaces Work

```
Same Terraform Configuration

        │
        ▼

+--------------------+
|  Workspace: dev    |
|  terraform.tfstate |
+--------------------+

+--------------------+
| Workspace: prod    |
| terraform.tfstate  |
+--------------------+

+--------------------+
| Workspace: test    |
| terraform.tfstate  |
+--------------------+
```

Although the Terraform code is identical, each workspace maintains its own infrastructure state.

---

# Workspace Commands

## List Available Commands

```bash
terraform workspace
```

---

## Show Current Workspace

```bash
terraform workspace show
```

Example:

```text
default
```

---

## Create a New Workspace

```bash
terraform workspace new dev
```

Terraform creates the workspace and automatically switches to it.

Output:

```text
Created and switched to workspace "dev"
```

---

## Show Current Workspace

```bash
terraform workspace show
```

Output:

```text
dev
```

---

## Create Another Workspace

```bash
terraform workspace new prod
```

Output:

```text
Created and switched to workspace "prod"
```

---

## List All Workspaces

```bash
terraform workspace list
```

Example:

```text
default
dev
* prod
```

The asterisk (*) indicates the active workspace.

---

## Switch Between Workspaces

```bash
terraform workspace select dev
```

Output:

```text
Switched to workspace "dev"
```

---

# Example 1 – Same Configuration, Different State Files

Create **workspace.tf**

```terraform
resource "aws_instance" "myec2" {

  ami           = "ami-08a0d1e16fc3f61ea"

  instance_type = "t2.micro"

}
```

Run:

```bash
terraform plan
```

Terraform displays:

```text
Plan: 1 to add
```

Now switch to another workspace.

```bash
terraform workspace select prod
```

Run:

```bash
terraform plan
```

Again Terraform displays:

```text
Plan: 1 to add
```

Why?

Because the **prod workspace has its own state file**.

Terraform does not know an EC2 instance already exists in the **dev** workspace.

Each workspace is completely independent.

---

# Example 2 – Deploy Different Instance Types

Terraform provides a built-in variable:

```terraform
terraform.workspace
```

This returns the currently selected workspace.

Example values:

```
default

dev

prod
```

---

## Terraform Configuration

```terraform
locals {

  instance_type = {

    default = "t2.nano"

    dev     = "t2.micro"

    prod    = "m5.large"

  }

}

resource "aws_instance" "myec2" {

  ami           = "ami-08a0d1e16fc3f61ea"

  instance_type = local.instance_type[terraform.workspace]

}
```

---

# Result

| Workspace | Instance Type |
|------------|---------------|
| default | t2.nano |
| dev | t2.micro |
| prod | m5.large |

The same Terraform code now deploys different infrastructure based on the active workspace.

---

# Example 3 – Local File Based on Workspace

This example demonstrates workspaces without requiring an AWS account.

## main.tf

```terraform
locals {

  env_content = {

    default = "This is the generic default environment text."

    dev     = "Development Mode: Enabling debugging tools and mock endpoints."

    prod    = "PRODUCTION MODE: High security configurations active!"

  }

}

resource "local_file" "workspace_test" {

  filename = "${terraform.workspace}-config.txt"

  content  = local.env_content[terraform.workspace]

}
```

---

# Execution Steps

## Step 1

Initialize Terraform.

```bash
terraform init
```

---

## Step 2

Verify the current workspace.

```bash
terraform workspace show
```

Expected output:

```text
default
```

---

## Step 3

Create the Development workspace.

```bash
terraform workspace new dev
```

---

## Step 4

Run a plan.

```bash
terraform plan
```

Terraform displays:

```text
dev-config.txt will be created
```

---

## Step 5

Apply the configuration.

```bash
terraform apply -auto-approve
```

Terraform creates:

```
dev-config.txt
```

Contents:

```
Development Mode: Enabling debugging tools and mock endpoints.
```

---

## Step 6

Create the Production workspace.

```bash
terraform workspace new prod
```

---

## Step 7

Apply the configuration.

```bash
terraform apply -auto-approve
```

Terraform creates:

```
prod-config.txt
```

Contents:

```
PRODUCTION MODE: High security configurations active!
```

---

## Step 8

List all workspaces.

```bash
terraform workspace list
```

Example:

```text
default
dev
* prod
```

---

# Understanding `terraform.workspace`

Terraform provides the built-in variable:

```terraform
terraform.workspace
```

This automatically returns the currently active workspace.

Example:

| Active Workspace | Value Returned |
|------------------|----------------|
| default | default |
| dev | dev |
| prod | prod |

This allows you to write environment-aware Terraform code.

---

# Typical Use Cases

Terraform Workspaces are commonly used for:

- Development
- Testing
- QA
- UAT
- Production
- Disaster Recovery
- Feature Branch Deployments

---

# Limitations

Although workspaces are useful, they are **not recommended for managing large production environments**.

Reasons include:

- Shared backend configuration
- Shared Terraform code
- Risk of accidentally deploying to the wrong workspace
- Difficult access control for large teams

For enterprise environments, separate Terraform projects or directories are often preferred.

---

# Best Practices

- Use workspaces for small to medium-sized environments.
- Name workspaces clearly (`dev`, `qa`, `uat`, `prod`).
- Avoid hardcoding environment values.
- Use `terraform.workspace` to select variables dynamically.
- Always verify the active workspace before running `terraform apply`.
- Use remote backends for storing workspace state files securely.

---

# Summary

Terraform Workspaces provide a simple way to manage multiple environments using a single Terraform configuration. Each workspace maintains its own independent state file while sharing the same codebase. Combined with the built-in `terraform.workspace` variable, workspaces make it easy to customize infrastructure for different environments without duplicating Terraform code.
