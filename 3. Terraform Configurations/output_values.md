# Terraform Output Values

## What are Output Values?

Terraform **Output Values** are used to expose information about your infrastructure after it has been created.

Outputs extract values from the **Terraform state file** and display them in the terminal or make them available to other Terraform modules.

They are commonly used to display:

- EC2 Public IP addresses
- Elastic IP addresses
- Load Balancer DNS names
- Resource IDs
- File paths
- Database endpoints
- Any other useful resource attributes

---

## Documentation

https://developer.hashicorp.com/terraform/language/values/outputs

---

# Why Use Output Values?

Output values help you:

- Display important infrastructure details after deployment.
- Extract values from the Terraform state file.
- Share information between Terraform modules.
- Provide values to CI/CD pipelines.
- Avoid manually checking cloud consoles for resource details.

---

# Basic Example

## Terraform Configuration

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "lb" {
  domain = "vpc"
}

output "public_ip" {
  value = aws_eip.lb.public_ip
}
```

---

# Apply the Configuration

```bash
terraform apply -auto-approve
```

### Output

```text
Outputs:

public_ip = "52.211.187.248"
```

Terraform displays the Elastic IP address after creating the resource.

---

# Output Customization Examples

## 1. Output a Single Attribute

```hcl
output "public_ip" {
  value = aws_eip.lb.public_ip
}
```

Output:

```text
public_ip = "52.211.187.248"
```

---

## 2. Output a Formatted String

```hcl
output "public_ip" {
  value = "https://${aws_eip.lb.public_ip}:8080"
}
```

Output:

```text
public_ip = "https://52.211.187.248:8080"
```

This is useful for generating URLs or connection strings.

---

## 3. Output an Entire Resource

```hcl
output "public_ip" {
  value = aws_eip.lb
}
```

Output:

```text
public_ip = {
  address        = ...
  allocation_id  = ...
  arn            = ...
  domain         = "vpc"
  public_dns     = ...
  public_ip      = "52.211.187.248"
}
```

This returns the complete resource object instead of a single attribute.

---

# Local File Example

## Terraform Configuration

```hcl
resource "local_file" "foo" {
  content  = "Hello from Sri!"
  filename = "${path.module}/Sri.txt"
}

output "foo_file_id" {
  value       = local_file.foo.id
  description = "The ID/hash of the created file"
}

output "foo_file_path" {
  value       = local_file.foo.filename
  description = "The path where the file was saved"
}
```

---

# Refresh the State

```bash
terraform refresh
```

Example output:

```text
Outputs:

foo_file_id = "db112f8aa6ead9d4565cae7dd679206c9871dba7"
foo_file_path = "./Sri.txt"
```

---

# View All Output Values

```bash
terraform output
```

Example:

```text
foo_file_id = "db112f8aa6ead9d4565cae7dd679206c9871dba7"
foo_file_path = "./Sri.txt"
```

---

# View a Specific Output

```bash
terraform output foo_file_path
```

Output:

```text
"./Sri.txt"
```

---

# Common Terraform Output Commands

Initialize Terraform:

```bash
terraform init
```

Create an execution plan:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Apply without confirmation:

```bash
terraform apply -auto-approve
```

Refresh the state:

```bash
terraform refresh
```

Display all outputs:

```bash
terraform output
```

Display a specific output:

```bash
terraform output <output_name>
```

Destroy infrastructure:

```bash
terraform destroy -auto-approve
```

---

# Output Types

| Output Value | Result |
|--------------|--------|
| `aws_eip.lb.public_ip` | Returns a single attribute |
| `"https://${aws_eip.lb.public_ip}:8080"` | Returns a formatted string |
| `aws_eip.lb` | Returns the entire resource object |
| `local_file.foo.filename` | Returns the file path |
| `local_file.foo.id` | Returns the resource ID |

---

# Key Points

- Output values extract information from the **Terraform state file**.
- Outputs are displayed after `terraform apply`.
- Use `terraform output` to display all output values.
- Use `terraform output <output_name>` to display a specific output.
- Outputs can return:
  - Single attributes
  - Formatted strings
  - Entire resource objects
- Output values are useful for automation, CI/CD pipelines, debugging, and sharing values between Terraform modules.
