# Terraform: Desired State vs Current State

Terraform works by comparing the **desired state** (defined in your `.tf` files) with the **current state** (the actual infrastructure and the Terraform state file). It then determines the actions required to make the current infrastructure match the desired configuration.

---

# Base Code Used

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t2.micro"
}
```

---

# Step 1: Create the EC2 Instance

```bash
terraform apply
```

Terraform creates an EC2 instance with:

- AMI: `ami-0fa3fe0fa7920f68e`
- Instance Type: `t2.micro`

At this point:

- **Desired State:** `t2.micro`
- **Current State:** `t2.micro`

Both states match.

---

# Step 2: Modify the Infrastructure Manually

Using the AWS Management Console, change the instance type from:

```text
t2.micro
```

to

```text
t2.small
```

Now:

- **Desired State:** `t2.micro` (Terraform configuration)
- **Current State:** `t2.small` (Actual AWS resource)

The infrastructure has **drifted** from the Terraform configuration.

---

# Step 3: Detect the Drift

Run:

```bash
terraform plan
```

Terraform compares the desired and current states and displays the differences.

Example output:

```text
~ instance_type = "t2.small" -> "t2.micro"
```

This indicates Terraform plans to change the instance back to `t2.micro` to match the configuration.

---

# Step 4: Make the Desired State Empty

Remove the resource block from `ec2.tf` so the file is empty:

```hcl
# Resource removed
```

Now:

- **Desired State:** No EC2 instance
- **Current State:** EC2 instance exists

---

# Step 5: Apply the Changes

Run:

```bash
terraform apply
```

Terraform detects that the EC2 instance is no longer part of the desired state and plans to destroy it.

Example output:

```text
Plan: 0 to add, 0 to change, 1 to destroy.
```

After confirmation, the EC2 instance is deleted.

---

# Summary

| Desired State | Current State | Terraform Action |
|---------------|---------------|------------------|
| `t2.micro` | `t2.micro` | No changes required |
| `t2.micro` | `t2.small` | Change instance back to `t2.micro` |
| No EC2 resource | EC2 instance exists | Destroy the EC2 instance |

---

## Key Concept

Terraform is **declarative**. You describe **what** your infrastructure should look like (the **desired state**), and Terraform compares it with the **current state** to determine the actions needed to bring the infrastructure back into alignment.
