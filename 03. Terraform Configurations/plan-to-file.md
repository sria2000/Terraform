# Terraform Save Plan to a File

## What is a Saved Plan?

Terraform allows you to **save the execution plan to a file** instead of applying it immediately.

A saved plan captures the exact infrastructure changes that Terraform intends to make. This helps ensure that the infrastructure is deployed **exactly as reviewed and approved**, even if the Terraform configuration files are modified later.

Saved plans are commonly used in **CI/CD pipelines** and **production environments** where planned changes require review and approval before implementation.

---

## Documentation

https://developer.hashicorp.com/terraform/cli/commands/plan

---

# Why Save a Plan?

Saving a Terraform plan provides several benefits:

- Review infrastructure changes before deployment.
- Ensure the exact reviewed plan is applied.
- Support change approval processes.
- Maintain consistency between planning and deployment.
- Generate machine-readable JSON output for automation and reporting.

---

# Example

## Terraform Configuration

```hcl
resource "local_file" "foo" {
  content  = "Hello World"
  filename = "terraform.txt"
}
```

---

# Save the Plan

```bash
terraform plan -out=infra.plan
```

Example:

```bash
terraform plan -out=sri.plan
```

Terraform saves the execution plan into a **binary plan file**.

---

# Sample Output

```text
Terraform used the selected providers to generate the following execution plan.

Plan: 3 to add, 0 to change, 0 to destroy.

Saved the plan to:

sri.plan

To perform exactly these actions, run the following command:

terraform apply "sri.plan"
```

---

# Apply the Saved Plan

```bash
terraform apply sri.plan
```

Terraform executes **exactly** what was stored in the saved plan.

---

# Important Behavior

Suppose you save a plan:

```bash
terraform plan -out=sri.plan
```

Then you modify your Terraform configuration:

```hcl
content = "Modified Content"
```

If you still run:

```bash
terraform apply sri.plan
```

Terraform **does not use the modified configuration**.

Instead, it applies the **original saved plan** exactly as it was generated.

This guarantees consistency between the reviewed plan and the deployed infrastructure.

---

# View the Saved Plan

Although the saved plan is a **binary file**, Terraform can display it in a human-readable format.

```bash
terraform show sri.plan
```

---

# View as JSON

Terraform can also output the saved plan as JSON.

```bash
terraform show -json sri.plan
```

This is useful for:

- Automation
- CI/CD pipelines
- Policy validation
- Auditing
- Integration with other tools

You can also format the JSON using `jq`:

```bash
terraform show -json sri.plan | jq
```

Or copy the JSON output into an online JSON formatter for easier reading.

---

# Why is the Plan File Binary?

The `.plan` file is stored in a **binary format**, so it cannot be read directly using a text editor.

Instead, use:

```bash
terraform show sri.plan
```

or

```bash
terraform show -json sri.plan
```

to inspect its contents.

---

# Commands Summary

Create a saved plan:

```bash
terraform plan -out=infra.plan
```

Apply the saved plan:

```bash
terraform apply infra.plan
```

Display the saved plan:

```bash
terraform show infra.plan
```

Display the saved plan as JSON:

```bash
terraform show -json infra.plan
```

Pretty-print the JSON using `jq`:

```bash
terraform show -json infra.plan | jq
```

---

# Common Use Cases

- Production deployments
- Change management and approval workflows
- CI/CD pipelines
- Infrastructure auditing
- Peer review before implementation
- Compliance and governance requirements

Many organizations require documented proof of planned infrastructure changes before deployment. A saved Terraform plan provides this evidence and allows reviewers to approve the exact changes that will be applied.

---

# Key Points

- `terraform plan -out=<file>` saves the execution plan to a binary file.
- A saved plan ensures the exact reviewed changes are applied.
- Changes made to the Terraform configuration **after** the plan is saved are **not** included when applying the saved plan.
- Use `terraform show` to view the plan in a human-readable format.
- Use `terraform show -json` to generate JSON output for automation and integrations.
- Saved plans are widely used in production environments to support review, approval, and controlled deployments.
