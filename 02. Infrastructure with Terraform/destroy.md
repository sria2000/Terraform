# Terraform Destroy

Use the following commands to destroy Terraform-managed resources.

## Destroy all resources

```bash
terraform destroy
```

## Destroy a specific resource

```bash
terraform destroy -target=aws_instance.myec2
```

> **Note:** Using the `-target` option is useful when you want to destroy only a specific resource instead of the entire infrastructure.

## Important

After destroying a resource, make sure you **remove** or **comment out** the corresponding resource block in your Terraform configuration (`.tf`) files.

Otherwise, running:

```bash
terraform plan
```

or

```bash
terraform apply
```

will detect the missing resource and attempt to recreate it.
