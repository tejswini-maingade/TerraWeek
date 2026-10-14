# ☁️ Day 3 Cheat Sheet: Providers & Resources

Quick reference for [Day 3](./README.md).

---

## 🔌 Provider Setup

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = { Project = "terraweek", ManagedBy = "terraform" }
  }
}
```

Authenticate with `aws configure` or env vars (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`). Never hard-code keys.

## 📦 Resource, Data Source & References

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "tws-${var.environment}-logs"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.al2023.id   # reference a data source
  instance_type = "t3.micro"
  tags          = { Bucket = aws_s3_bucket.logs.id }   # implicit dependency
}
```

## 🔁 Loops & Conditionals

```hcl
resource "aws_s3_bucket" "many" {
  for_each = toset(["app", "logs", "backups"])
  bucket   = "tws-${each.key}"
}

resource "aws_instance" "copies" {
  count         = var.create ? 2 : 0
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"
}
```

## ♻️ Lifecycle

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
  ignore_changes        = [tags]
}
```

## 🕸️ Dependencies

```hcl
depends_on = [aws_s3_bucket.logs]   # only when there is no implicit reference
```

## 🔍 Inspect Your Infra

```bash
terraform state list     # everything Terraform manages
terraform graph          # dependency graph (pipe into graphviz)
terraform plan           # read the diff: + create, ~ update, -/+ replace
```

> 💸 Always run `terraform destroy` after practising.

---

