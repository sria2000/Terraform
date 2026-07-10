# Terraform Providers and Provisioners

## Overview

Terraform uses **Providers** and **Provisioners** to interact with external systems and automate infrastructure deployment.

In an organisation, an end-to-end solution may require:

* Creating infrastructure
* Installing software
* Configuring applications
* Executing commands locally or remotely

Example:

```
Terraform
    |
    |
AWS Provider
    |
    |
Launch EC2 Instance
    |
    |
Provisioner
    |
    |
Install Software
```

---

# Terraform Providers

## What are Providers?

Providers allow Terraform to communicate with external platforms and APIs.

Examples:

* AWS
* Azure
* Google Cloud
* Kubernetes
* GitHub
* Monitoring platforms

A provider enables Terraform to create and manage resources in a specific environment.

---

# Provider Documentation

Official Documentation:

https://www.terraform.io/docs/providers/index.html

---

# Types of Providers

Common Terraform providers:

| Provider   | Purpose                          |
| ---------- | -------------------------------- |
| AWS        | Manage AWS infrastructure        |
| Azure      | Manage Microsoft Azure resources |
| Google     | Manage GCP resources             |
| Kubernetes | Manage Kubernetes objects        |
| Wavefront  | Manage monitoring resources      |

---

# AWS Provider Example

## aws.tf

```hcl
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}
```

Explanation:

* Uses AWS provider
* Provider version must be compatible with 2.x
* Deploy resources in `us-east-1`

---

# Wavefront Provider Example

## wavefront.tf

```hcl
provider "wavefront" {
   address = "spaceape.wavefront.com"
}
```

---

# Downloading Custom Provider Plugin

Example: Download Wavefront provider plugin

```bash
wget https://github.com/spaceapegames/terraform-provider-wavefront/releases/download/v2.1.1/terraform-provider-wavefront_v2.1.1_darwin_amd64
```

Create Terraform plugin directory:

```bash
mkdir ~/terraform.d/plugins
```

Move and rename provider:

```bash
mv terraform-provider-wavefront_v2.1.1_darwin_amd64 terraform-provider-wavefront_v2.1.1

mv terraform-provider-wavefront_v2.1.1 ~/.terraform.d/plugins/
```

---

# Terraform Provisioners

## What are Provisioners?

Provisioners allow Terraform to execute commands on:

* Local machine
* Remote machine

Common use cases:

* Install software
* Run scripts
* Configure servers after creation

Example:

```
EC2 Instance Created
        |
        |
Install nginx
        |
        |
Start nginx Service
```

---

# Types of Provisioners

Terraform supports three main provisioners:

| Provisioner | Description                            |
| ----------- | -------------------------------------- |
| local-exec  | Executes commands on Terraform machine |
| remote-exec | Executes commands on remote resource   |
| file        | Copies files to remote resource        |

---

# 1. Local-Exec Provisioner

## Purpose

`local-exec` executes commands on the machine where Terraform is running.

Example use case:

After EC2 creation:

* Retrieve private IP
* Save IP address into a file

Documentation:

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

---

## Base Code

```hcl
resource "aws_instance" "myec2" {

   ami           = "ami-04e5276ebb8451442"
   instance_type = "t2.micro"

}
```

---

## Using Local-Exec

```hcl
resource "aws_instance" "myec2" {

   ami           = "ami-04e5276ebb8451442"
   instance_type = "t2.micro"


   provisioner "local-exec" {

      command = "echo ${self.private_ip} >> server_ip.txt"

   }

}
```

Output:

```
server_ip.txt

172.31.x.x
```

---

# 2. Remote-Exec Provisioner

## Purpose

`remote-exec` executes commands on the remote resource after it is created.

Example:

* Connect to EC2 using SSH
* Install nginx
* Start nginx service

Documentation:

Remote Exec:

https://www.terraform.io/language/resources/provisioners/remote-exec

Connection:

https://www.terraform.io/language/resources/provisioners/connection

File Function:

https://www.terraform.io/language/functions/file

---

## Base Code

```hcl
resource "aws_instance" "myec2" {

   ami           = "ami-04e5276ebb8451442"
   instance_type = "t2.micro"

}
```

---

## Remote-Exec Example

```hcl
resource "aws_instance" "myec2" {

   ami           = "ami-04e5276ebb8451442"

   instance_type = "t2.micro"

   key_name = "terraform-key"

   vpc_security_group_ids = [
      "sg-0edf854d7112cfbf4"
   ]


   connection {

      type        = "ssh"

      user        = "ec2-user"

      private_key = file("./terraform-key.pem")

      host        = self.public_ip

   }


   provisioner "remote-exec" {

      inline = [

        "sudo yum -y install nginx",

        "sudo systemctl start nginx"

      ]

   }

}
```

---

# Multiple Provisioners

Terraform allows multiple provisioners inside the same resource.

## Example 1

```hcl
resource "aws_iam_user" "lb" {

  name = "demoiamuser"


  provisioner "local-exec" {

    command = "echo local-exec provisioner is starting"

  }

}
```

---

## Example 2 - Multiple local-exec

```hcl
resource "aws_iam_user" "lb" {

  name = "demoiamuser"


  provisioner "local-exec" {

    command = "echo local-exec provisioner is starting"

  }


  provisioner "local-exec" {

    command = "echo local-exec provisioner is starting for 2nd time"

  }

}
```

Execution order:

```
Provisioner 1
      |
      |
Provisioner 2
```

---

# Create-Time and Destroy-Time Provisioners

## Create-Time Provisioner

Runs after resource creation.

## Destroy-Time Provisioner

Runs when:

```
terraform destroy
```

is executed.

---

# Example: Create and Destroy Provisioners

```hcl
resource "aws_iam_user" "lb" {

  name = "provisioner-user"


  provisioner "local-exec" {

    command = "echo This is creation time provisioner"

  }


  provisioner "local-exec" {

    command = "echo This is destroy time provisioner"

    when = destroy

  }

}
```

---

# Resource Tainting

If a **creation-time provisioner fails**:

1. Terraform marks the resource as **tainted**
2. Next `terraform apply` destroys and recreates the resource

Flow:

```
Provisioner Failure
        |
        |
Resource Tainted
        |
        |
Next terraform apply
        |
        |
Destroy + Recreate Resource
```

---

# Simulating Provisioner Failure

Example:

```hcl
resource "aws_iam_user" "lb" {

  name = "provisioner-user"


  provisioner "local-exec" {

    command = "This is creation time provisioner"

  }


  provisioner "local-exec" {

    command = "echo This is destroy time provisioner"

    when = destroy

  }

}
```

The first provisioner fails because:

```
This is creation time provisioner
```

is not a valid command.

The resource becomes tainted.

---

# Provisioner Failure Behaviour

Terraform provides:

```hcl
on_failure
```

to control what happens when a provisioner fails.

---

# Failure Options

| Option   | Behaviour                                 |
| -------- | ----------------------------------------- |
| fail     | Stop execution and return error (default) |
| continue | Ignore error and continue execution       |

---

# Example: Continue on Failure

## Base Code

```hcl
resource "aws_iam_user" "lb" {

  name = "demo-provisioner-user"


  provisioner "local-exec" {

    command = "echo1 This is creation time provisioner"

  }

}
```

`echo1` is not a valid command, therefore it fails.

---

## Continue After Failure

```hcl
resource "aws_iam_user" "lb" {

  name = "demo-provisioner-user"


  provisioner "local-exec" {

    command = "echo1 This is creation time provisioner"

    on_failure = continue

  }

}
```

Terraform ignores the failure and continues.

---

# Summary

| Feature                  | Description                                             |
| ------------------------ | ------------------------------------------------------- |
| Provider                 | Allows Terraform to communicate with external platforms |
| local-exec               | Runs commands locally                                   |
| remote-exec              | Runs commands on remote resources                       |
| file provisioner         | Copies files to remote systems                          |
| Create-time provisioner  | Runs after resource creation                            |
| Destroy-time provisioner | Runs during terraform destroy                           |
| Tainted Resource         | Resource recreated during next apply                    |
| on_failure               | Controls provisioner failure handling                   |

---

# Best Practice

Terraform provisioners should be used carefully.

Preferred alternatives:

* Cloud-init
* AWS User Data
* Ansible
* Configuration Management tools

Provisioners should generally be considered a **last resort** when Terraform cannot perform the required action natively.

