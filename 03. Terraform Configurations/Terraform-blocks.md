# Terraform Check Blocks and Moved Blocks

Terraform provides additional features to improve infrastructure validation and resource management:

- **Check Blocks** – Validate infrastructure outside the normal resource lifecycle.
- **Moved Blocks** – Rename or move resources without recreating them.

---

# Terraform Check Blocks

A **check block** allows Terraform to validate infrastructure **outside the normal resource lifecycle**.

Unlike **preconditions** and **postconditions**, check blocks **do not prevent Terraform from creating or updating resources**.

Instead, they report warnings if a validation fails.

---

# Why Use Check Blocks?

Sometimes you want to verify something **after infrastructure has been deployed**, but you do not want the deployment to fail.

Examples:

- Is a website responding?
- Is an API reachable?
- Has the AWS Budget been exceeded?
- Is a database accepting connections?
- Is an application health endpoint returning HTTP 200?

---

# Key Features

- Runs independently of the resource lifecycle.
- Each **check block** must contain at least **one `assert` block**.
- Each **assert block** requires:
  - `condition`
  - `error_message`
- Failed assertions generate **warnings**, not errors.
- Terraform continues execution even if a check fails.

---

# Check Block Syntax

```hcl
check "check_name" {

  assert {

    condition = <boolean expression>

    error_message = "Custom error message"

  }

}
```

---

# Base Code

```hcl
data "http" "example" {

  url = "https://google.com"

}

resource "local_file" "foo" {

  content  = "Hi"

  filename = "${path.module}/foo.txt"

}
```

---

# Final Code

```hcl
check "website_checker" {

  data "http" "example" {

    url = "https://google1231233dsd.com"

  }

  assert {

    condition = data.http.example.status_code == 200

    error_message = "Website is not running. Please check."

  }

}

resource "local_file" "foo" {

  content  = "Hi"

  filename = "${path.module}/foo.txt"

}
```

---

# How It Works

Terraform attempts to access:

```text
https://google1231233dsd.com
```

The assertion checks:

```hcl
data.http.example.status_code == 200
```

If the website returns:

```text
200 OK
```

The check passes.

Otherwise:

Terraform displays a warning similar to:

```text
Warning:

Website is not running. Please check.
```

The local file resource is still created successfully.

---

# Execution Flow

```text
Terraform Apply
        │
        ▼
Create Resources
        │
        ▼
Run Check Block
        │
        ▼
Website Returns HTTP 200?
      ┌──────┴──────┐
      │             │
     Yes            No
      │             │
      ▼             ▼
 Continue      Display Warning
```

---

# Check Blocks vs Preconditions/Postconditions

| Feature | Check Block | Precondition | Postcondition |
|---------|-------------|--------------|---------------|
| Runs Before Resource Creation | No | Yes | No |
| Runs After Resource Creation | Yes | Yes | Yes |
| Stops Terraform Execution | No | Yes | Yes |
| Failure Type | Warning | Error | Error |
| Typical Use | Monitoring and health checks | Validate prerequisites | Validate deployed infrastructure |

---

# Common Use Cases

Use check blocks to:

- Verify a website is online.
- Confirm an API endpoint is responding.
- Check AWS Budget thresholds.
- Verify database connectivity.
- Validate DNS resolution.
- Monitor service availability.

---

# Continuous Validation

Check blocks become even more valuable when used in automated environments.

For example:

- CI/CD pipelines
- Scheduled Terraform runs
- Infrastructure monitoring

**HCP Terraform** can execute check blocks continuously using its **Continuous Validation** feature and notify administrators when checks begin to fail.

---

# Best Practices

- Use check blocks for health checks and operational monitoring.
- Keep assertions simple and meaningful.
- Remember that failed checks generate warnings, not errors.
- Use preconditions or postconditions if a failed validation should stop the deployment.

---

# Terraform Moved Blocks

As Terraform projects evolve, resource names and module structures often change.

For example:

- Renaming resources
- Refactoring modules
- Moving resources between modules

Without additional configuration, Terraform interprets a renamed resource as:

- Destroy the old resource.
- Create a new resource.

This can cause unnecessary downtime.

A **moved block** tells Terraform that the resource has only changed its address—not that it should be recreated.

---

# Why Use Moved Blocks?

Imagine you have already deployed a security group:

```hcl
resource "aws_security_group" "database_firewall" {

  name = "db_firewall"

}
```

After running:

```bash
terraform apply
```

The resource exists both in AWS and in the Terraform state.

Later, you decide that the resource name should be:

```text
payment_database_firewall
```

If you simply rename the resource block:

```hcl
resource "aws_security_group" "payment_database_firewall" {

  name = "db_firewall"

}
```

Terraform believes:

```text
database_firewall has been deleted.

payment_database_firewall is a new resource.
```

The next plan shows:

```text
Destroy database_firewall

Create payment_database_firewall
```

This is undesirable in production.

---

# Solution: Moved Block

Add a moved block:

```hcl
resource "aws_security_group" "payment_database_firewall" {

  name = "db_firewall"

}

moved {

  from = aws_security_group.database_firewall

  to   = aws_security_group.payment_database_firewall

}
```

Terraform now understands that the resource has only been renamed.

---

# Commands

View the plan:

```bash
terraform plan
```

Terraform updates the resource address in the state without recreating the infrastructure.

Apply the change:

```bash
terraform apply -auto-approve
```

---

# Execution Flow

Without a moved block:

```text
Old Resource
      │
      ▼
Destroy

      │
      ▼
Create New Resource
```

With a moved block:

```text
Old Resource Address

      │
      ▼
Update Terraform State

      │
      ▼
Same AWS Resource
```

No infrastructure changes occur.

---

# Moved Blocks vs `terraform state mv`

Terraform offers two methods for renaming resources:

| Feature | Moved Block | `terraform state mv` |
|---------|-------------|----------------------|
| Stored in Code | Yes | No |
| Shared with Team | Yes | No |
| Version Controlled | Yes | No |
| Suitable for Bulk Operations | No | Yes |
| Best For | Resource renaming and refactoring | Complex or scripted state changes |

---

# When to Use Moved Blocks

Use moved blocks when:

- Renaming resources.
- Refactoring Terraform modules.
- Moving resources between modules.
- Preserving existing infrastructure.
- Avoiding unnecessary resource recreation.

---

# Best Practices

- Always use moved blocks when renaming resources already managed by Terraform.
- Commit moved blocks to version control so all team members benefit.
- Use `terraform state mv` for complex or bulk state migrations.
- Review `terraform plan` before applying changes.

---

# Summary

| Feature | Purpose |
|---------|---------|
| Check Block | Validate infrastructure without stopping Terraform execution. |
| Assert Block | Defines the condition and warning message for a check block. |
| Moved Block | Renames or relocates Terraform-managed resources without recreating them. |
| `terraform state mv` | Manually moves resource addresses in the Terraform state. |

---

# Key Takeaways

- **Check blocks** validate infrastructure outside the normal resource lifecycle.
- Failed **check block assertions** generate warnings and do not halt Terraform operations.
- **Preconditions** and **postconditions** stop Terraform if their conditions fail.
- **Moved blocks** preserve existing infrastructure when resource names or module paths change.
- Prefer **moved blocks** over recreating resources whenever you are only changing Terraform configuration, not the actual infrastructure.
