
#### GitHub Provider Terraform:

https://registry.terraform.io/providers/integrations/github/latest/docs

Code Used:

```sh

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = "your-token-here"
}

resource "github_repository" "example" {
  name        = "sri-example-repository"
  description = "Sri's codebase"

  visibility = "public"

}
```
#### Initialize and Apply:
```sh
terraform init
terraform plan
terraform apply
```

#### How to create token
```sh
* GitHub -> Settings -> Developer Settings ->Personal Access Tokens -> Generate new token
* name - terraform
 * repo access - All repositories { Change to selected repo as required }
* Permission - Administration - Change to Read and Write - GENERATE TOKEN
```
