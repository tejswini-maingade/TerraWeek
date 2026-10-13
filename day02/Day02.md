# 🚀 TerraWeek Day 02 — HCL Deep Dive: Variables, Types & Expressions

## 📌 Overview

Day 02 of the **#TerraWeek Challenge by TWS Community Builders** focused on understanding HashiCorp Configuration Language (HCL), Terraform input variables, data types, local values, outputs, built-in functions, and variable precedence.

The goal was to write more reusable, readable, and maintainable Terraform configurations.

## 🎯 Learning Objectives

- Understand HCL syntax, blocks, arguments, and expressions.
- Define input variables with types and default values.
- Implement variable validation and sensitive variables.
- Use local values to simplify configuration.
- Create Terraform outputs.
- Explore built-in Terraform functions using `terraform console`.
- Understand variable precedence.
- Deploy and manage an Nginx container using Terraform and Docker.

## 🛠️ Tasks Completed

### Task 1: Understanding HCL Syntax

Explored the basic structure of Terraform configuration files, including:

- Blocks and arguments
- Expressions and string interpolation
- Variable references
- Resource attribute references
- Operators and conditional expressions

Example:

```hcl
resource "local_file" "greeting" {
  filename = "greeting.txt"
  content  = "Hello, Terraform!"
}
```

### Task 2: Terraform Variables and Data Types

Practiced defining variables using Terraform's type system.

| Data type | Example |
|---|---|
| `string` | `"dev"` |
| `number` | `8080` |
| `bool` | `true` |
| `list(string)` | `["nginx", "redis"]` |
| `map(string)` | `{ owner = "devops" }` |
| `set(string)` | `["nginx", "redis"]` |
| `object({...})` | Structured configuration |
| `tuple([...])` | Values with defined types and positions |

Also explored:

- Variable descriptions and default values
- Validation rules using `validation` blocks
- Sensitive variables using `sensitive = true`

Example validation:

```hcl
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```
<img width="993" height="713" alt="Screenshot 2026-10-13 135923" src="https://github.com/user-attachments/assets/a7103f47-46d3-4b88-b2f0-3e0e668ed623" />

### Task 3: Locals, Outputs, and Built-in Functions

Used local values to calculate reusable configuration values and outputs to display useful information.

Example:

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  uppercase_names = [for name in var.names : upper(name)]
}
```

Explored these built-in functions:

- `upper()` — converts text to uppercase.
- `merge()` — combines maps.
- `join()` — combines strings with a separator.
- `length()` — returns the length of a collection or string.
- `format()` — formats strings.
- `lookup()` — retrieves a value from a map.

Used `terraform console` to evaluate expressions interactively.

<img width="858" height="583" alt="Screenshot 2026-10-13 140141" src="https://github.com/user-attachments/assets/72677c71-f5db-4d55-b96d-9fc12a06fce4" />

### Task 4: Deploying Nginx with Terraform and Docker

Worked with the provided Terraform Docker example to understand how Terraform manages container resources.

Commands used:

```bash
cd example
terraform init
terraform fmt
terraform validate

terraform plan \
  -var="container_name=tws-web" \
  -var="external_port=8080"

terraform apply \
  -var="container_name=tws-web" \
  -var="external_port=8080"
```
<img width="1659" height="1018" alt="Screenshot 2026-10-13 140510" src="https://github.com/user-attachments/assets/6296cafa-d1d6-4c0e-8e7a-08309a80e076" />
<img width="1840" height="967" alt="Screenshot 2026-10-13 140553" src="https://github.com/user-attachments/assets/3d980629-04ec-4ade-a92c-6d90b1b614cd" />

After deployment, the application can be accessed at:

`http://localhost:8080`
<img width="1917" height="524" alt="Screenshot 2026-10-13 140624" src="https://github.com/user-attachments/assets/a233a64f-8ce9-4b68-9171-63642343b8e4" />

Verified the running container with:

```bash
docker ps
terraform output
```
<img width="1881" height="61" alt="Screenshot 2026-10-13 140650" src="https://github.com/user-attachments/assets/92917341-faa8-4685-ae2f-7b1c0356b4be" />

Cleaned up the resources after testing:

```bash
terraform destroy \
  -var="container_name=tws-web" \
  -var="external_port=8080"
```
<img width="1787" height="1020" alt="Screenshot 2026-10-13 140811" src="https://github.com/user-attachments/assets/ad03b0a5-aba0-4043-b273-0a5de6099e62" />

**Note:** Docker must be running and accessible from the terminal for this task.

### Bonus: Variable Precedence and Expressions

Explored how Terraform selects variable values from different sources.

General precedence, from higher to lower:

1. `-var` and `-var-file` command-line arguments
2. `*.auto.tfvars` files
3. `terraform.tfvars` and `terraform.tfvars.json`
4. Environment variables such as `TF_VAR_environment`
5. Variable default values


## 📂 Repository Structure

```text
day02/
├── README.md
├── DAY02-NOTES.md
├── variables.tf
├── locals.tf
├── outputs.tf
└── example/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

*The exact files in `example/` depend on the provided starter code. Keep the Docker example's Terraform files separate from the Day 02 learning configuration at the `day02/` root.*

## 💡 Key Takeaways

- Variables make Terraform configurations reusable and configurable.
- Type constraints help maintain consistent input values.
- Validation rules prevent invalid configuration values.
- Sensitive variables help prevent values from being displayed in normal CLI output, but they do not encrypt or securely store secrets.
- Locals reduce duplication and simplify expressions.
- Outputs make important resource information accessible.
- Built-in functions help transform and combine data.
- Variable precedence determines which value Terraform uses when multiple sources define the same variable.
- Terraform can manage Docker resources through a provider.

## 🚀 Skills Practiced

`Terraform` · `HCL` · `Input Variables` · `Data Types` · `Validation` · `Locals` · `Outputs` · `Terraform Functions` · `Docker` · `Infrastructure as Code`

## 📚 Challenge Information

- **Challenge:** TerraWeek
- **Day:** 02
- **Topic:** HCL Deep Dive — Variables, Types & Expressions
- **Community:** TWS Community Builders

Continuing my journey toward becoming a **DevOps Engineer**, one practical task at a time!

#TerraWeek #Terraform #HCL #DevOps #InfrastructureAsCode #Docker #CloudComputing #TWSCommunityBuilders
