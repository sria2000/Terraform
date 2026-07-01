# Terraform Notes (Beginner Overview)

---

## 🌍 What is Terraform?

Terraform was created by HashiCorp.

It is an **Infrastructure as Code (IaC)** tool used to define and provision cloud infrastructure using code.

---

## ☁️ Infrastructure as Code (IaC)

IaC means managing infrastructure using code instead of manual configuration.

### Common IaC tools:

- AWS → CloudFormation Templates (CFT)
- Azure → Azure Resource Manager (ARM) templates
- OpenStack → Heat templates
- Multi-cloud → Terraform

---

### IaC can be written using:

- Python
- Shell scripts
- YAML
- JSON
- Cloud-specific templates

---

## 📦 What CloudFormation does (AWS example)

CloudFormation Templates (CFT) are used to create resources such as:

- EC2 (Virtual Machines)
- S3 Buckets
- Storage services (similar to Blob storage in Azure)

---

## 🚀 Why Terraform?

Terraform is popular because it is **multi-cloud**.

It works across:

- AWS
- Azure
- Google Cloud Platform (GCP)
- OpenStack

### Key Idea:
You write one configuration (HCL), and Terraform provisions infrastructure across different cloud providers.

---

## 🧠 Key Concepts

- Uses **HCL (HashiCorp Configuration Language)**
- Infrastructure is defined as code
- Terraform interacts with cloud providers via APIs
- Widely used in DevOps & Cloud Engineering
- Helps build scalable and highly available infrastructure

---

## 🔄 Terraform Competitors

- Crossplane
- Pulumi

---

## ⚙️ How Terraform Works

1. You write HCL configuration files
2. Terraform reads the configuration
3. It calls cloud provider APIs (AWS / Azure / GCP)
4. It creates or updates infrastructure

---

## 🛠️ Installing Terraform

Official download:

https://developer.hashicorp.com/terraform/install

### Windows Install (PowerShell)

```bash
winget install HashiCorp.Terraform
```

### Verify Installation

```bash
terraform --version
```

Example output:

```text
Terraform v1.15.5
```

---

## 💻 Development Setup

Recommended tools:

- Git Bash (Windows)
- VS Code

---

## ☁️ GitHub Codespaces (Recommended)

Codespaces is a cloud-based development environment hosted by GitHub.

### Steps:

- Launch Codespace
- Add Dev Container configuration
- Install tools:
  - Terraform
  - tflint
  - tfsec / tfgrype (security tools)
- Optionally add AWS CLI dev container
- Rebuild container (first setup may take time)

---

## 🧰 AWS CLI Installation (Windows)

```bash
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

---

## 🔐 AWS Setup

- Login to AWS Console
- Enable MFA (Duo / Authenticator app)
- Create:
  - Access Key
  - Secret Access Key

---

## 🔗 Connect AWS from Terminal / Codespaces

```bash
aws configure
```

Enter:

- AWS Access Key
- AWS Secret Key
- Default region

---

### Example Region:

```text
eu-west-2   # London
```

---

### ❌ Wrong Example:

```text
es-east-1
```

---

## 🧪 Test AWS Connection

```bash
aws s3 ls
```

---

## ⚠️ Common Issue

If you see:

```text
Could not connect to endpoint URL: https://s3.es-east-1.amazonaws.com/
```

### Meaning:
Wrong AWS region is configured.

---

## 🛠️ Fix

```bash
aws configure set region eu-west-2
```

---
