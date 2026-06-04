🚀 Getting Started with Terraform (Key Concepts)

Terraform is an Infrastructure as Code (IaC) tool that lets you define and manage infrastructure using configuration files.

🔌 Provider

A provider is a plugin that connects Terraform to a platform like AWS, Azure, or Google Cloud.
It tells Terraform where and how to create resources.

🧱 Resource

A resource is an actual infrastructure component you want to create or manage.
Examples:

Virtual machines
Databases
Storage buckets
Networks

Each resource has a type and configuration settings.

📦 Module

A module is a reusable bundle of Terraform code.
It helps you:

Avoid repeating code
Organize infrastructure better
Share configurations easily

Modules can be custom or from the Terraform Registry.

📄 Configuration File

Terraform uses .tf files to define infrastructure.

Common file:

main.tf

These files define:

Providers
Resources
Variables
Outputs
🔁 Variable

A variable is a placeholder for values you don’t want hardcoded.

Example use cases:

Region
Instance size
Environment name

They make code reusable and flexible.

📤 Output

Outputs are values displayed after Terraform runs.
They are useful for:

Showing results (like IP addresses)
Passing data to other systems
🗂 State File

Terraform keeps a state file (terraform.tfstate) that tracks:

What resources exist
Their current configuration

This is critical for knowing what to create, update, or delete.

📊 Plan

terraform plan shows a preview of changes:

What will be created
What will be modified
What will be destroyed

Think of it as a “dry run”.

⚙️ Apply

terraform apply executes the changes:

Creates infrastructure
Updates existing resources
Deletes removed resources
🌍 Workspace

Workspaces allow multiple environments in one setup:

dev
staging
production

Each workspace has its own state file.

🗄 Remote Backend

A backend stores the state file remotely instead of locally.

Examples:

Amazon S3
Azure Blob Storage
Terraform Cloud

Benefits:

Collaboration
Security
No local state conflicts
🧠 Summary

Terraform works like this:
Write config → Plan changes → Apply infrastructure → Track state