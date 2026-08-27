# Debugging Terraform

Debugging is an essential part of working with Terraform. Terraform provides detailed logging that helps identify issues with configuration, state, providers, and API communication.

---

# Detailed Logging

Terraform can generate detailed logs while executing commands such as:

```bash
terraform plan
```

Logging is controlled using the **TF_LOG** environment variable.

---

# TF_LOG

`TF_LOG` enables Terraform debug logging.

Terraform supports multiple log levels in order of **decreasing verbosity**:

| Log Level | Description |
|-----------|-------------|
| `TRACE` | Most detailed logging. Shows almost everything Terraform is doing. |
| `DEBUG` | Detailed debugging information. |
| `INFO` | General operational information. |
| `WARN` | Warning messages. |
| `ERROR` | Only error messages. |

> **Note:** `TRACE` generates a very large amount of output and is typically used for advanced troubleshooting.

---

# TF_LOG_PATH

By default, log output is displayed on the console.

To save logs to a file, use the **TF_LOG_PATH** environment variable.

This forces Terraform to append log output to the specified file whenever logging is enabled.

Example:

```text
terraform.txt
```

---

# Example

## Base Code (tf-logs.tf)

```hcl
resource "local_file" "foo" {

  content  = "foo!"

  filename = "${path.module}/foo.txt"

}
```

---

# Setting Environment Variables

## Windows (Command Prompt)

Enable INFO logging:

```cmd
set TF_LOG=INFO
```

Enable TRACE logging:

```cmd
set TF_LOG=TRACE
```

Save logs to a file:

```cmd
set TF_LOG_PATH=terraform.txt
```

---

## Linux / macOS

Enable INFO logging:

```bash
export TF_LOG=INFO
```

Enable TRACE logging:

```bash
export TF_LOG=TRACE
```

Save logs to a file:

```bash
export TF_LOG_PATH=terraform.txt
```

---

## Windows PowerShell

```powershell
$env:TF_LOG="INFO"

$env:TF_LOG_PATH="terraform.txt"

terraform plan
```

After execution, open:

```text
terraform.txt
```

to review the detailed logs.

---

# Example Workflow

1. Enable logging.

```powershell
$env:TF_LOG="TRACE"
```

2. Specify a log file.

```powershell
$env:TF_LOG_PATH="terraform.txt"
```

3. Run Terraform.

```bash
terraform plan
```

4. Open **terraform.txt** and review the generated logs.

---

# Troubleshooting Terraform

Terraform issues generally fall into one of four categories.

---

## 1. Language (HCL)

**Primary User Interface:** HashiCorp Configuration Language (HCL)

Typical issues:

- Syntax errors
- Invalid arguments
- Incorrect expressions
- Missing variables
- Typographical mistakes

Example:

```hcl
resource "aws_instance" "web" {

  ami =

}
```

Terraform reports an HCL parsing error.

---

## 2. State Issues

Terraform stores resource metadata in the **state file**.

Typical problems include:

- State file out of sync
- Corrupted state
- Missing resources
- State lock issues
- Manual infrastructure changes outside Terraform

Examples:

- `terraform.tfstate` is outdated.
- State lock cannot be acquired.
- Resource already exists but is missing from state.

---

## 3. Terraform Core

Terraform Core is responsible for:

- Building the resource graph
- Dependency management
- API communication
- Planning and applying infrastructure

Typical issues:

- Terraform application bugs
- Resource dependency problems
- Graph generation failures

If you suspect a Terraform Core issue, check the official GitHub repository to see if it has already been reported.

---

## 4. Provider Errors

Providers act as plugins that communicate with cloud services such as AWS, Azure, or GCP.

Typical provider issues include:

- Authentication failures
- Authorization errors
- API communication failures
- Incorrect resource mapping
- Provider bugs

Examples:

- Invalid AWS credentials
- Expired access tokens
- Unsupported resource arguments
- Provider version incompatibility

Updating to the latest provider version often resolves these issues.

---

# Summary of Troubleshooting Areas

| Area | Description | Common Issues |
|------|-------------|---------------|
| Language | HCL configuration | Syntax errors, invalid expressions |
| State | Resource metadata | State out of sync, lock issues |
| Terraform Core | Resource graph and planning | Dependency or core application issues |
| Provider | Cloud provider plugins | Authentication, API, plugin compatibility |

---

# Reporting Terraform Bugs

If you believe you have found a Terraform bug:

1. Reproduce the issue.
2. Enable detailed logging (`TF_LOG=TRACE`).
3. Save the logs using `TF_LOG_PATH`.
4. Search the Terraform GitHub repository to see if the issue has already been reported.
5. If not, create a new issue with:
   - Terraform version
   - Provider version
   - Operating system
   - Terraform configuration
   - Log output
   - Steps to reproduce the problem

---

# Best Practices

- Start with `INFO` logging for general troubleshooting.
- Use `TRACE` only when detailed diagnostics are required.
- Save logs using `TF_LOG_PATH` for easier analysis.
- Keep Terraform and provider plugins updated.
- Check existing GitHub issues before reporting a new bug.

---

# Key Interview Points

- `TF_LOG` enables Terraform debug logging.
- `TF_LOG_PATH` writes logs to a file.
- `TRACE` is the most verbose log level.
- Terraform issues typically fall into four categories:
  - Language (HCL)
  - State
  - Terraform Core
  - Provider
- Always collect logs before troubleshooting or reporting a bug.
