# Terraform Commands — Full Reference
### (Command + Sample Output + One-line Explanation)

---

## 1. Basics

**`terraform version`**
```
Terraform v1.8.0
on linux_amd64
```
Shows the installed Terraform version and platform.

**`terraform help`**
```
Usage: terraform [global options] <subcommand> [args]
Main commands:
  init    Prepare your working directory
  plan    Show changes required by the current config
  apply   Create or update infrastructure
  ...
```
Displays general help and list of subcommands.

**`terraform -help`**
```
All commands:
  apply, console, destroy, fmt, get, graph, import, init, output,
  plan, providers, refresh, show, state, taint, test, validate, ...
```
Lists every available Terraform command.

---

## 2. Initialization

**`terraform init`**
```
Initializing the backend...
Initializing provider plugins...
- Installing hashicorp/google v5.30.0...
Terraform has been successfully initialized!
```
Initializes the working directory, downloads providers/modules.

**`terraform init -upgrade`**
```
Upgrading modules...
- Installing hashicorp/google v5.31.0 (upgraded from v5.30.0)...
```
Upgrades providers and modules to the latest allowed versions.

**`terraform init -reconfigure`**
```
Initializing the backend...
Backend configuration changed!
Terraform has been successfully initialized!
```
Re-initializes the backend, ignoring any saved configuration.

**`terraform init -backend=false`**
```
Initializing provider plugins...
Terraform has been successfully initialized! (no backend configured)
```
Initializes without setting up a backend (e.g. for quick local checks).

**`terraform init -migrate-state`**
```
Backend configuration changed!
Do you want to migrate all workspaces to "gcs"?
  Enter a value: yes
Successfully migrated state.
```
Migrates existing state to a newly configured backend.

---

## 3. Validation & Formatting

**`terraform validate`**
```
Success! The configuration is valid.
```
Checks configuration syntax and internal consistency.

**`terraform validate -json`**
```json
{"valid":true,"error_count":0,"warning_count":0,"diagnostics":[]}
```
Same validation, output as machine-readable JSON.

**`terraform fmt`**
```
main.tf
variables.tf
```
Reformats listed files to canonical style and prints filenames changed.

**`terraform fmt -recursive`**
```
modules/network/main.tf
environments/prod/main.tf
```
Formats `.tf` files in the current directory and all subdirectories.

**`terraform fmt -check`**
```
main.tf
(exit code 3 — file not formatted)
```
Checks formatting without modifying files; useful in CI.

**`terraform fmt -diff`**
```diff
-resource "google_compute_instance" "web" {
-  name = "web"
+resource "google_compute_instance" "web" {
+  name = "web"
```
Shows formatting differences without applying them.

---

## 4. Planning

**`terraform plan`**
```
Plan: 2 to add, 0 to change, 0 to destroy.
```
Previews changes Terraform will make to reach desired state.

**`terraform plan -out=tfplan`**
```
Saved the plan to: tfplan
```
Saves the generated plan to a file for later use with `apply`.

**`terraform plan -var="instance_type=e2-medium"`**
```
Plan: 1 to add, 0 to change, 0 to destroy.
```
Passes a single variable value at runtime.

**`terraform plan -var-file=prod.tfvars`**
```
Plan: 3 to add, 1 to change, 0 to destroy.
```
Uses variable values defined in a `.tfvars` file.

**`terraform plan -target=google_compute_instance.web`**
```
Plan: 1 to add, 0 to change, 0 to destroy.
(only google_compute_instance.web evaluated)
```
Limits the plan to a specific resource.

**`terraform plan -destroy`**
```
Plan: 0 to add, 0 to change, 4 to destroy.
```
Previews what would be destroyed, without destroying anything.

**`terraform plan -refresh=false`**
```
Plan: 1 to add, 0 to change, 0 to destroy.
(skipped refreshing state)
```
Skips checking real infrastructure state before planning (faster).

---

## 5. Apply

**`terraform apply`**
```
Do you want to perform these actions?
  Enter a value: yes
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
Applies planned changes after confirmation.

**`terraform apply tfplan`**
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
Applies a previously saved plan exactly as reviewed.

**`terraform apply -auto-approve`**
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
Applies changes without the interactive confirmation prompt.

**`terraform apply -var-file=prod.tfvars`**
```
Apply complete! Resources: 3 added, 1 changed, 0 destroyed.
```
Applies changes using values from a variables file.

**`terraform apply -target=google_compute_instance.web`**
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
Applies changes to only the specified resource.

---

## 6. Destroy

**`terraform destroy`**
```
Do you really want to destroy all resources?
  Enter a value: yes
Destroy complete! Resources: 4 destroyed.
```
Destroys all resources managed by current state.

**`terraform destroy -auto-approve`**
```
Destroy complete! Resources: 4 destroyed.
```
Destroys all resources without confirmation prompt.

**`terraform destroy -target=google_compute_instance.web`**
```
Destroy complete! Resources: 1 destroyed.
```
Destroys only the specified resource.

---

## 7. State Management

**`terraform state list`**
```
google_compute_instance.web
google_storage_bucket.data
```
Lists all resources currently tracked in the state file.

**`terraform state show google_compute_instance.web`**
```
# google_compute_instance.web:
resource "google_compute_instance" "web" {
    name = "web"
    zone = "us-central1-a"
    ...
}
```
Shows full attribute details of one resource in state.

**`terraform state pull`**
```json
{"version":4,"terraform_version":"1.8.0","resources":[...]}
```
Downloads and prints the current state (e.g. from a remote backend).

**`terraform state push`**
```
(no output on success)
```
Uploads a local state file to the configured backend.

**`terraform state mv google_compute_instance.web google_compute_instance.app`**
```
Move "google_compute_instance.web" to "google_compute_instance.app"
Successfully moved 1 object(s).
```
Renames/moves a resource in state without destroying it.

**`terraform state rm google_compute_instance.web`**
```
Removed google_compute_instance.web
Successfully removed 1 resource instance(s).
```
Removes a resource from state (infra remains, Terraform forgets it).

**`terraform state replace-provider registry.terraform.io/hashicorp/google registry.terraform.io/hashicorp/google-beta`**
```
Successfully replaced provider for 3 resources.
```
Changes the provider source associated with resources in state.

---

## 8. Outputs

**`terraform output`**
```
instance_ip = "34.123.45.67"
bucket_name = "my-app-bucket"
```
Displays all defined output values.

**`terraform output instance_ip`**
```
"34.123.45.67"
```
Displays a single specific output value.

**`terraform output -json`**
```json
{"instance_ip":{"value":"34.123.45.67","type":"string"}}
```
Displays all outputs as JSON.

**`terraform output -raw instance_ip`**
```
34.123.45.67
```
Prints just the raw value with no quotes — useful in shell scripts.

---

## 9. Variables & Console

**`terraform console`**
```
> var.region
"us-central1"
> length(["a","b","c"])
3
```
Opens an interactive REPL to test expressions and variable values.

---

## 10. Workspaces

**`terraform workspace list`**
```
  default
* dev
  prod
```
Lists all workspaces (current one marked with `*`).

**`terraform workspace show`**
```
dev
```
Shows the name of the currently active workspace.

**`terraform workspace new dev`**
```
Created and switched to workspace "dev"!
```
Creates a new workspace and switches to it.

**`terraform workspace select prod`**
```
Switched to workspace "prod".
```
Switches to an existing workspace.

**`terraform workspace delete dev`**
```
Deleted workspace "dev"!
```
Deletes a workspace (must not be currently active).

---

## 11. Providers & Modules

**`terraform providers`**
```
.
└── provider[registry.terraform.io/hashicorp/google] ~> 5.0
```
Lists all providers required by the configuration.

**`terraform providers mirror ./local-mirror`**
```
- Mirroring hashicorp/google 5.30.0 to local-mirror/...
```
Downloads provider plugins to a local directory (offline use).

**`terraform get`**
```
- web in modules/web-server
```
Downloads modules referenced in the configuration.

**`terraform get -update`**
```
- web in modules/web-server (updated)
```
Re-downloads modules even if already cached locally.

---

## 12. Import

**`terraform import google_compute_instance.web projects/my-project/zones/us-central1-a/instances/web-1`**
```
google_compute_instance.web: Importing from ID "projects/my-project/.../web-1"...
Import successful!
```
Brings an existing infrastructure resource under Terraform management.

---

## 13. Refresh & Show

**`terraform refresh`**
```
google_compute_instance.web: Refreshing state...
```
Updates the state file to match real infrastructure.

**`terraform show`**
```
# google_compute_instance.web:
resource "google_compute_instance" "web" {
  name = "web"
  ...
}
```
Displays current state (or a saved plan) in human-readable form.

**`terraform show -json`**
```json
{"format_version":"1.2","values":{"root_module":{"resources":[...]}}}
```
Displays state or plan details as JSON.

---

## 14. Graph

**`terraform graph`**
```
digraph G {
  "google_compute_instance.web" -> "google_compute_network.vpc"
}
```
Outputs a dependency graph in DOT format.

---

## 15. Debugging & Logs

**`TF_LOG=TRACE terraform apply`**
```
2026/06/30 10:01:02 [TRACE] terraform: building graph...
2026/06/30 10:01:02 [TRACE] ProviderTransformer...
```
Enables the most verbose logging level for deep debugging.

**`TF_LOG=DEBUG terraform plan`**
```
2026/06/30 10:01:02 [DEBUG] checking for provider plugin...
```
Enables debug-level logging (less noisy than TRACE).

**`TF_LOG_PATH=terraform.log terraform apply`**
```
(logs written to terraform.log instead of terminal)
```
Writes log output to a file rather than stdout.

---

## 16. Lock & Recovery

**`terraform force-unlock 1f3d4b2a-1234-5678-9abc-def012345678`**
```
Terraform state has been successfully unlocked!
```
Manually releases a stuck state lock (use with caution).

---

## 17. Advanced / Rare Commands

**`terraform taint google_compute_instance.web`**
```
Resource instance google_compute_instance.web has been marked as tainted.
```
Marks a resource for forced recreation on next apply (deprecated, prefer `-replace`).

**`terraform untaint google_compute_instance.web`**
```
Resource instance google_compute_instance.web has been successfully untainted.
```
Removes the taint marker from a resource.

**`terraform test`**
```
vpc_test.tftest.hcl... pass
Success! 1 passed, 0 failed.
```
Runs `.tftest.hcl` test files against your configuration.

---

## 18. Cleanup (Manual)

**`rm -rf .terraform`**
```
(no output — directory removed)
```
Deletes the local provider/module cache; forces re-init next time.

**`rm terraform.tfstate`**
```
(no output — file removed)
```
Deletes the local state file (only safe if not using a remote backend).

---

## 19. Terraform Workflow (One-Line Summary)

```
terraform init → terraform validate → terraform plan → terraform apply → terraform state ... → terraform destroy
```
The standard end-to-end lifecycle of a Terraform-managed deployment.
