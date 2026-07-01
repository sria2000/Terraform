Terraform Notes (Beginner Overview)
🌍 What is Terraform?

Terraform was created by HashiCorp.

It is an Infrastructure as Code (IaC) tool used to define and provision cloud infrastructure using code.

☁️ Infrastructure as Code (IaC)

IaC means managing infrastructure using code instead of manual configuration.

Common IaC tools:

AWS → CloudFormation Templates (CFT)
Azure → Azure Resource Manager (ARM) templates
OpenStack → Heat templates
Multi-cloud → Terraform

IaC can be written using:

Python
Shell scripts
YAML
JSON
Templates (Cloud-specific formats)
📦 What CloudFormation does (AWS example)

CloudFormation Templates (CFT) are used to create resources such as:

EC2 (VMs)
S3 buckets
Storage resources (like Blob equivalents in other clouds)
🚀 Why Terraform?

Terraform is used because it is multi-cloud.

It works across:

AWS
Azure
GCP
OpenStack
Key Idea:

You write one configuration (HCL) and Terraform applies it to different cloud providers.

🧠 Key Concepts
Uses HCL (HashiCorp Configuration Language)
Infrastructure is defined as code
Terraform talks to cloud providers via APIs
Used heavily by DevOps & Cloud Engineers
Helps build scalable and highly available infrastructure
🔄 Terraform Competitors
Crossplane
Pulumi
⚙️ How Terraform Works
You write HCL configuration files
Terraform reads the file
It calls cloud provider APIs (AWS/Azure/GCP)
It creates or updates infrastructure
🛠️ Installing Terraform
Official download:

https://developer.hashicorp.com/terraform/install

Windows install (PowerShell):
winget install HashiCorp.Terraform
Verify installation:
terraform --version

Example:

Terraform v1.15.5
💻 Development Setup

Recommended tools:

Git Bash (Windows)
VS Code
☁️ GitHub Codespaces (Recommended for practice)

Codespaces is a cloud-based development environment hosted by GitHub.

Steps:
Launch Codespace
Add Dev Container configuration
Search and add:
Terraform
tflint
tfsec / tfgrype (security tools)
Optionally add:
AWS CLI dev container (keep default settings)
Rebuild container (first setup takes time)
🧰 AWS CLI Installation (Windows)
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
🔐 AWS Setup
Login to AWS Console
Use MFA (Duo / authenticator app)
Create:
Access Key
Secret Access Key
🔗 Connect AWS from Codespace / Terminal
aws configure

Enter:

AWS Access Key
AWS Secret Key
Default region (IMPORTANT)

Example region:

eu-west-2   # London

❌ Wrong example:

es-east-1
🧪 Test AWS Connection
aws s3 ls
⚠️ Common Issue (Your Error)

If you see:

Could not connect to endpoint URL: https://s3.es-east-1.amazonaws.com/

It means:
👉 Incorrect AWS region is configured

Fix:

aws configure set region eu-west-2
