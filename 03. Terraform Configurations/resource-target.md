# Terraform Resource Targeting

**Resource Targeting** allows you to plan, apply, or destroy **specific resources** instead of processing your entire Terraform configuration.

By default, Terraform works on **all resources** defined in your configuration.

---

# Why Use Resource Targeting?

Consider the following project structure:

```
terraform-project/
├── ec2.tf
├── iam.tf
├── local_file.tf
```

Running:

```bash
terraform apply
```

will evaluate and apply **every resource** across all `.tf` files.

Sometimes, during development, you may only want to test a single resource without affecting the others.

This is where **Resource Targeting** becomes useful.

---

# Example Use Case

Suppose your project contains **10 resources**.

- 9 resources are still under development.
- 1 resource is complete and ready for testing.

Instead of applying all resources, you can target just the completed resource.

For example, test only the `local_file` resource while leaving the remaining resources untouched.

---

# Important Note

> **Avoid using `-target` as part of your normal Terraform workflow.**

Terraform itself warns against routine use of resource targeting.

Use it only for exceptional situations such as:

- Testing an individual resource during development
- Recovering from failed deployments
- Resolving state issues
- When Terraform specifically recommends using `-target` in an error message

For normal infrastructure deployments, always use:

```bash
terraform plan
terraform apply
```

---

# Base Code

```hcl
resource "aws_iam_user" "this" {
  name = "test-aws-user"
}

resource "aws_security_group" "allow_tls" {
  name = "terraform-firewall"
}

resource "local_file" "foo" {
  content  = "foo!"
  filename = "${path.module}/foo.txt"
}
```

---

# Resource Address

The syntax for targeting a resource is:

```text
<RESOURCE_TYPE>.<RESOURCE_NAME>
```

Example:

```text
local_file.foo
```

Where:

- Resource Type → `local_file`
- Resource Name → `foo`

---

# Terraform Commands

## Target a Resource During Planning

```bash
terraform plan -target=local_file.foo
```

Terraform generates a plan **only** for the `local_file.foo` resource.

---

## Apply Only One Resource

```bash
terraform apply -target=local_file.foo
```

Only the specified resource is created or updated.

---

## Destroy Only One Resource

```bash
terraform destroy -target=local_file.foo
```

Only the targeted resource is destroyed.

---

# Example Output

Running:

```bash
terraform apply -target=local_file.foo
```

Terraform detected that the resource had changed.

The plan showed:

```text
Terraform will perform the following actions:

# local_file.foo must be replaced

-/+ destroy and then create replacement
```

Terraform replaced only the `local_file.foo` resource.

```
Plan:
1 to add
0 to change
1 to destroy
```

The IAM user and Security Group were **not modified**.

---

# Terraform Warning

Terraform displays the following warning when using `-target`:

```text
Warning: Resource targeting is in effect

The -target option is not for routine use,
and is provided only for exceptional situations.
```

This warning reminds you that Terraform is **not evaluating the complete infrastructure**.

Some dependent resources or outputs may not be updated.

---

# Verify Everything Is Up-to-Date

After using `-target`, always run:

```bash
terraform plan
```

This verifies that there are no remaining infrastructure changes.

If Terraform reports:

```text
No changes.
Infrastructure is up-to-date.
```

your environment is fully synchronized.

---

# Advantages

- Test a single resource during development.
- Speeds up testing of individual resources.
- Avoids modifying unrelated infrastructure.
- Useful for troubleshooting or recovering from failed deployments.

---

# Disadvantages

- Terraform does not evaluate the entire dependency graph.
- Outputs may become temporarily inconsistent.
- Other pending infrastructure changes are ignored.
- Can leave infrastructure in a partially updated state.
- Not recommended for normal day-to-day deployments.

---

# Best Practices

- Use `terraform plan` and `terraform apply` for normal deployments.
- Use `-target` only for exceptional situations.
- Always run a full `terraform plan` after using `-target`.
- Never rely on resource targeting as part of a regular deployment pipeline.
- Let Terraform manage the complete dependency graph whenever possible.

---

# Summary

| Command | Description |
|----------|-------------|
| `terraform plan` | Plans all resources |
| `terraform apply` | Applies all resources |
| `terraform destroy` | Destroys all managed resources |
| `terraform plan -target=local_file.foo` | Plans only the specified resource |
| `terraform apply -target=local_file.foo` | Applies only the specified resource |
| `terraform destroy -target=local_file.foo` | Destroys only the specified resource |

---

# Documentation

Terraform Resource Targeting

https://developer.hashicorp.com/terraform/cli/commands/plan#resource-targeting
