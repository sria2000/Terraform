# Terraform fmt

## Introduction

When multiple people work on the same Terraform project, files can become inconsistently formatted, making them harder to read, review, and debug.

The **`terraform fmt`** command automatically formats Terraform configuration files to match Terraform's **canonical format and style**.

Using `terraform fmt` improves:

- Readability
- Consistency
- Code reviews
- Team collaboration

---

# Syntax

```bash
terraform fmt
```

---

# Example

## Before Formatting (`demo.tf`)

```hcl
resource "local_file" "foo" {
      content  = "Hello from Sri!"
  filename = "${path.module}/Sri.txt"
}
```

Run:

```bash
terraform fmt
```

---

## After Formatting

```hcl
resource "local_file" "foo" {
  content  = "Hello from Sri!"
  filename = "${path.module}/Sri.txt"
}
```

Terraform automatically aligns the indentation and spacing according to the standard Terraform style.

---

# View Formatting Changes

Instead of modifying the file immediately, you can view the changes using the `-diff` option.

```bash
terraform fmt -diff
```

> **Note:** The `diff` command is available on Unix/Linux/macOS systems.

Example output:

```diff
-      content  = "Hello from Sri!"
+  content  = "Hello from Sri!"
```

This helps you see exactly what Terraform will change.

---

# Recursive Formatting

To format all Terraform files in the current directory **and its subdirectories**, use:

```bash
terraform fmt -recursive
```

This is useful for large projects with multiple modules.

---

# Check Mode (Dry Run)

In CI/CD pipelines, you often want to verify whether Terraform files are correctly formatted **without modifying them**.

Use:

```bash
terraform fmt -check
```

### Return Codes

| Return Code | Meaning |
|-------------|---------|
| `0` | All files are correctly formatted |
| `3` | One or more files require formatting |

---

# Example (File Needs Formatting)

```powershell
PS D:\Terraform\TERRAFORMLAB> terraform fmt -check

data-sources-02.tf

PS D:\Terraform\TERRAFORMLAB> echo $?

False
```

On **Linux/macOS**, Terraform returns exit code:

```text
3
```

indicating that one or more files need formatting.

---

# Example (After Fixing the Formatting)

```powershell
PS D:\Terraform\TERRAFORMLAB> terraform fmt -check

PS D:\Terraform\TERRAFORMLAB> echo $?

True
```

On **Linux/macOS**, Terraform returns exit code:

```text
0
```

indicating that all files are properly formatted.

---

# Common `terraform fmt` Options

| Command | Description |
|----------|-------------|
| `terraform fmt` | Formats Terraform files in the current directory |
| `terraform fmt -diff` | Shows formatting differences before making changes |
| `terraform fmt -recursive` | Formats all Terraform files, including subdirectories |
| `terraform fmt -check` | Checks formatting without modifying files (ideal for CI/CD) |

---

# Benefits of Using `terraform fmt`

- Ensures consistent formatting across the project.
- Makes code easier to read and maintain.
- Reduces unnecessary formatting changes in Git commits.
- Simplifies code reviews.
- Enforces Terraform's standard coding style.
- Ideal for automated validation in CI/CD pipelines.

---

# Best Practices

- Run `terraform fmt` before every commit.
- Include `terraform fmt -check` in CI/CD pipelines.
- Use `terraform fmt -recursive` for multi-module projects.
- Combine with `terraform validate` to ensure both formatting and syntax are correct.

---

# Key Interview Points

- `terraform fmt` formats Terraform configuration files according to Terraform's standard style.
- It improves readability and consistency across teams.
- `terraform fmt -check` verifies formatting without modifying files, making it ideal for CI/CD pipelines.
- `terraform fmt -recursive` formats Terraform files in the current directory and all subdirectories.
- On Linux/macOS, `terraform fmt -check` returns:
  - **0** → All files are formatted correctly.
  - **3** → One or more files require formatting.
