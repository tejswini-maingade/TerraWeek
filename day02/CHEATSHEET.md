# 🧩 Day 2 Cheat Sheet: HCL, Variables & Expressions

Quick reference for [Day 2](./README.md).

---

## 🧱 Block Anatomy

```hcl
block_type "label_one" "label_two" {
  argument = value
}
```

## 🔤 Variable Types

```hcl
variable "name"    { type = string }
variable "count_n" { type = number }
variable "enabled" { type = bool }
variable "azs"     { type = list(string) }
variable "tags"    { type = map(string) }
variable "ids"     { type = set(string) }
variable "server" {
  type = object({
    name = string
    port = number
  })
}
```

## ✅ Validation, Defaults & Sensitive

```hcl
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "db_password" {
  type      = string
  sensitive = true
}
```

## 📍 Locals & Outputs

```hcl
locals {
  name_prefix = "tws-${var.environment}"
  tags        = merge(var.tags, { ManagedBy = "terraform" })
}

output "prefix" {
  value = local.name_prefix
}
```

## ⚙️ Useful Functions (try them in `terraform console`)

```hcl
upper("terraweek")                       # TERRAWEEK
join("-", ["tws", "terraweek"])          # tws-terraweek
merge({a = 1}, {b = 2})                  # {a=1, b=2}
lookup({a = 1}, "a", 0)                  # 1
length(["a", "b"])                       # 2
format("%s-%03d", "web", 7)              # web-007
[for s in var.names : upper(s)]          # for expression
var.enabled ? "yes" : "no"               # conditional
```

## 🔀 Ways to Set Variables

```bash
terraform apply -var 'environment=prod'
terraform apply -var-file=prod.tfvars
export TF_VAR_environment=prod
```

Precedence (highest first): `-var` / `-var-file` → `*.auto.tfvars` → `terraform.tfvars` → `TF_VAR_*` → `default`.

---


⬅️ Back to [Day 2 tasks](./README.md)
