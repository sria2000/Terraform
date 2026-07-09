# Terraform Comments

Comments are used in Terraform configuration files to:

- Explain the purpose of resources and configurations.
- Add notes for other team members.
- Temporarily disable sections of Terraform code.
- Improve code readability and maintenance.

Terraform supports **three types of comments**:

1. Single-line comments using `#`
2. Single-line comments using `//`
3. Multi-line comments using `/* ... */`

---

# 1. Single-Line Comment Using `#`

The `#` symbol is the most commonly used comment style in Terraform.

Everything after `#` on that line is ignored by Terraform.

Example:

```hcl
# We are running Null Provisioner

resource "null_resource" "demo_run" {

  provisioner "local-exec" {

    command = "echo Null Provisioner has completed > sample.txt"

  }
}
```

Terraform ignores:

```hcl
# We are running Null Provisioner
```

---

# 2. Single-Line Comment Using `//`

`//` can also be used for single-line comments.

Example:

```hcl
// This is second type of comment

resource "null_resource" "demo_run" {

  provisioner "local-exec" {

    command = "echo Null Provisioner has completed > sample.txt"

  }
}
```

Both `#` and `//` work the same way for single-line comments.

---

# 3. Multi-Line Comments Using `/* ... */`

Multi-line comments are used when comments span multiple lines.

Syntax:

```hcl
/*
Line 1
Line 2
Line 3
*/
```

Example:

```hcl
/*
Line 1
Line 2
Line 3
*/

resource "null_resource" "demo_run" {

  provisioner "local-exec" {

    command = "echo Null Provisioner has completed > sample.txt"

  }
}
```

Terraform ignores everything between:

```hcl
/*
```

and

```hcl
*/
```

---

# Commenting Out Terraform Code

Multi-line comments can be used to temporarily disable Terraform resources.

Example:

```hcl
/*
resource "null_resource" "demo_run2" {

  provisioner "local-exec" {

    command = "echo Null Provisioner has completed > sample.txt"

  }
}
*/
```

Terraform will completely ignore this resource.

---

# Complete Example

```hcl
# We are running Null Provisioner.

// This is second type of comment.

/*
Line 1
Line 2
Line 3
*/

resource "null_resource" "demo_run" {

  provisioner "local-exec" {

    command = "echo Null Provisioner has completed > sample.txt"

  }
}

/*
resource "null_resource" "demo_run2" {

  provisioner "local-exec" {

    command = "echo Null Provisioner has completed > sample.txt"

  }
}
*/
```

---

# Comments Best Practices

- Use comments to explain **why** something is configured, not what the code already shows.
- Keep comments updated when code changes.
- Avoid unnecessary comments that make files harder to read.
- Use comments when explaining complex Terraform logic.
- Use multi-line comments to temporarily disable code during testing.

---

# Summary

| Comment Type | Syntax | Usage |
|--------------|--------|-------|
| Single-line | `#` | Most common Terraform comment |
| Single-line | `//` | Alternative single-line comment |
| Multi-line | `/* ... */` | Comments spanning multiple lines or disabling code |

---

# Key Takeaway

Terraform ignores comments completely during execution.

They are only for **documentation, explanation, and temporarily disabling code**.
