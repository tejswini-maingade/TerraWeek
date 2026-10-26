# ☁️ TerraWeek — Terraform Challenge

<p align="center">
  <strong>Learning Infrastructure as Code with Terraform and AWS</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC?logo=terraform&logoColor=white" alt="Terraform"/>
  <img src="https://img.shields.io/badge/AWS-Cloud%20Computing-FF9900?logo=amazonaws&logoColor=white" alt="AWS"/>
  <img src="https://img.shields.io/badge/Status-completed-blue" alt="Status"/>
  <img src="https://img.shields.io/badge/Challenge-TerraWeek-green" alt="TerraWeek"/>
</p>

## 👋 About This Repository

Welcome to my **TerraWeek Terraform Challenge** repository!

This repository documents my hands-on journey learning Terraform and Infrastructure as Code (IaC). My goal is to understand how to provision, manage, and automate cloud infrastructure using reusable, maintainable, and version-controlled Terraform configurations.

Instead of learning only the theory, I am completing practical daily challenges, documenting my work, troubleshooting errors, and sharing my progress with the DevOps community.

This challenge is part of my ongoing journey toward becoming a skilled **DevOps / Cloud Engineer**.

## 🎯 Learning Objectives

- Understand Infrastructure as Code (IaC).
- Learn Terraform syntax, providers, resources, and data sources.
- Provision AWS infrastructure using Terraform.
- Work with variables, outputs, and reusable modules.
- Understand Terraform state management and remote backends.
- Implement state locking and infrastructure drift management.
- Build reusable infrastructure for multiple environments.
- Provision Kubernetes infrastructure using Terraform and Amazon EKS.
- Follow infrastructure automation and security best practices.
- Develop practical troubleshooting and problem-solving skills.

## 🛠️ Technologies and Tools

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| Amazon Web Services (AWS) | Cloud infrastructure |
| HCL | Terraform configuration language |
| Linux / Ubuntu | Command-line environment |
| Git and GitHub | Version control and documentation |
| Amazon S3 | Remote Terraform state storage |
| DynamoDB | State locking in the configured S3 backend |
| Amazon VPC | Network infrastructure |
| Amazon EC2 | Virtual machines |
| Amazon EKS | Managed Kubernetes |
| Terraform Modules | Reusable infrastructure components |

---


## 🚀 Terraform Workflow

The following commands are part of my regular Terraform workflow.

### 1. Initialize Terraform

```bash
terraform init
```

Downloads the required providers and initializes the working directory.

### 2. Validate Configuration

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and internally consistent.

### 3. Format Configuration

```bash
terraform fmt -recursive
```

Formats Terraform files consistently.

### 4. Preview Infrastructure Changes

```bash
terraform plan
```

Shows the proposed changes before they are applied.

### 5. Provision Infrastructure

```bash
terraform apply
```

Creates or updates infrastructure according to the Terraform configuration after approval.

### 6. Inspect State

```bash
terraform state list
terraform show
```

Displays resources tracked in the current Terraform state.

### 7. Destroy Test Infrastructure

```bash
terraform destroy
```

Destroys resources managed by the configuration after confirmation. I use this carefully for temporary learning environments to avoid unnecessary AWS costs.

## 🗂️ Key Concepts I Am Practicing

### Terraform Fundamentals
- Providers and resources
- Variables and outputs
- Data sources
- Resource dependencies
- Meta-arguments

### State Management
- Local and remote state
- S3 backend configuration
- State locking
- Resource import
- State migration and recovery
- State drift detection and reconciliation

### Reusable Infrastructure
- Custom Terraform modules
- Terraform Registry modules
- Input variables and outputs
- Terraform workspaces
- Environment-specific configurations

### Cloud and Kubernetes
- AWS networking with VPCs and subnets
- EC2 instance provisioning
- Security groups and routing
- Amazon EKS cluster provisioning
- Infrastructure automation

## 🔐 Security and Best Practices

I aim to follow these practices throughout the challenge:

- Never commit AWS access keys, passwords, private keys, or sensitive Terraform state.
- Use IAM roles and least-privilege permissions where practical.
- Add `.terraform/` and local state files to `.gitignore`.
- Review `terraform plan` before applying changes.
- Enable remote-state versioning and configure locking where supported.
- Keep reusable infrastructure organized into modules.
- Pin provider versions appropriately and commit `.terraform.lock.hcl`.
- Clean up temporary AWS resources to avoid unexpected charges.
- Treat Terraform state as sensitive because it may contain confidential infrastructure data.

Example `.gitignore`:

```gitignore
# Terraform working directory
**/.terraform/*

# Local Terraform state
*.tfstate
*.tfstate.*

# Crash logs
crash.log
crash.*.log

# Variable files that may contain secrets
*.tfvars
*.tfvars.json

# Override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# CLI configuration
.terraformrc
terraform.rc
```

**Note:** Commit `.terraform.lock.hcl` so provider selections remain reproducible. Do not ignore it.

## 🧠 Challenges and Troubleshooting

During hands-on practice, I document errors and their solutions, including:

- Terraform initialization and provider errors
- AWS IAM permission issues
- Backend configuration and state migration problems
- State locking and resource import errors
- Resource dependency and configuration mismatches
- Terraform module and variable errors
- AWS infrastructure provisioning issues

Each challenge helps me improve my understanding of infrastructure automation and troubleshooting.

## 📸 Practical Evidence

For each completed challenge, I aim to include:

- Terraform configuration files
- Important terminal commands and outputs
- Screenshots of successful AWS resources
- Explanation of the concepts learned
- Errors encountered and their solutions
- Cleanup and verification steps

## 📈 My Learning Approach

My approach is simple:

1. Learn the concept.
2. Write Terraform configuration.
3. Validate and deploy the infrastructure.
4. Troubleshoot errors.
5. Verify the results.
6. Document the solution.
7. Share my learning publicly.

I believe consistent hands-on practice is one of the best ways to build real-world DevOps skills.

## 🙏 Acknowledgements

A special thank you to **Shubham Londhe and TrainWithShubham** for the learning resources, practical challenges, and guidance throughout this DevOps journey.

I am grateful to the DevOps community for sharing knowledge and encouraging continuous learning.

## 🔗 Connect With Me

- **GitHub:** [tejswini-maingade](https://github.com/tejswini-maingade)
- **TerraWeek Repository:** [View My Terraform Challenges](https://github.com/tejswini-maingade/TerraWeek)
- **LinkedIn:** [Connect With Me](https://www.linkedin.com/in/tejswini-maingade/)

## 🌱 Final Thoughts

This repository represents my commitment to learning Terraform, AWS, and Infrastructure as Code through consistent practical work.

Every challenge is an opportunity to improve my skills, understand cloud infrastructure more deeply, and become better prepared for real-world DevOps and Cloud Engineering roles.

**Learn. Build. Break. Fix. Document. Repeat.**

---

<p align="center">
  <strong>#TerraWeek #Terraform #AWS #DevOps #InfrastructureAsCode #TrainWithShubham</strong>
</p>
