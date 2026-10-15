# ☁️ TerraWeek Day 03 — Providers, Resources, Meta-Arguments & AWS Infrastructure

![Terraform](https://img.shields.io/badge/Terraform-Infrastructure_as_Code-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud_Provider-FF9900?logo=amazonaws&logoColor=white)
![Linux](https://img.shields.io/badge/Environment-Ubuntu_WSL-E95420?logo=ubuntu&logoColor=white)
![Status](https://img.shields.io/badge/Challenge-Day_03-blue)

## 📌 Overview

Day 03 of the TerraWeek Challenge focuses on learning how Terraform interacts with cloud providers, manages infrastructure, reads existing cloud information, and controls resource creation and lifecycle.

In this assignment, I use **Terraform, AWS, AWS CLI, and Ubuntu on WSL** to understand Infrastructure as Code (IaC) and practice provisioning a basic cloud network and compute environment.

The assignment also covers Terraform meta-arguments such as `count`, `for_each`, `depends_on`, and `lifecycle`, along with planning, applying, updating, and destroying infrastructure.

## 🎯 Learning Objectives

- Understand Terraform providers and version constraints.
- Configure the AWS provider and authenticate securely.
- Understand resources versus data sources.
- Discover an Amazon Linux 2023 AMI dynamically.
- Build a VPC, public subnet, Internet Gateway, route table, security group, and EC2 instance.
- Understand Terraform dependency management.
- Practice `count` and `for_each`.
- Explore lifecycle rules and resource replacement.
- Read Terraform plans and inspect Terraform state.
- Safely destroy test infrastructure and avoid unnecessary cloud costs.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| Amazon Web Services (AWS) | Cloud infrastructure |
| AWS CLI | Authentication and AWS operations |
| Ubuntu WSL | Linux development environment |
| Amazon EC2 | Virtual machine |
| Amazon VPC | Isolated virtual network |
| Git and GitHub | Version control and documentation |


---

# ✅ Task 1: Providers & Version Pinning

## 1.1 What is a Terraform provider?

A provider is a plugin that allows Terraform to communicate with an external platform or service.

Examples include:

- AWS provider — manages AWS resources.
- Azure provider — manages Microsoft Azure resources.
- Google provider — manages Google Cloud resources.

For this assignment, AWS is the selected cloud provider.

## 1.2 Configure the Terraform and AWS provider versions

Example configuration:

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

### Explanation

- `required_version` specifies the compatible Terraform CLI versions.
- `required_providers` declares which provider plugins Terraform requires.
- `source = "hashicorp/aws"` identifies the official AWS provider.
- `version = "~> 6.0"` permits AWS provider releases in the 6.x series while excluding 7.x.
- `region = "ap-south-1"` selects the AWS Asia Pacific (Mumbai) region.

## 1.3 Why is version pinning important?

Version pinning improves consistency and helps prevent unexpected behavior caused by provider upgrades.

The pessimistic constraint operator `~>` permits updates within the specified compatibility range.

Examples:

| Version constraint | Meaning |
|---|---|
| `~> 6.0` | Allows compatible 6.x releases, excluding 7.x |
| `~> 6.2.0` | Allows 6.2.x releases, excluding 6.3.0 and later |
| `>= 1.5.0` | Allows Terraform versions 1.5.0 and later, subject to the other constraints |

The dependency lock file records the provider version selected during initialization.

## 1.4 Configure AWS authentication

Verify that the AWS CLI is installed:

```bash
aws --version
```

Check the currently authenticated identity:

```bash
aws sts get-caller-identity
```

If credentials are not configured, use:

```bash
aws configure
```

Provide your own AWS access key, secret key, region, and output format when prompted.

**Security best practices:**

- Never hard-code AWS credentials in Terraform files.
- Never commit credentials or secret-bearing variable files to GitHub.
- Use an appropriate IAM identity with only the permissions required for the assignment.
- Verify the account and region before creating resources.

## 1.5 Initialize the Terraform project

```bash
cd ~/TerraWeek/day03/example
terraform init
```

Terraform downloads the required provider plugins and initializes the working directory.

**Expected result:** Initialization completes successfully and creates or updates `.terraform.lock.hcl`.

---

# ✅ Task 2: Resources vs. Data Sources

## 2.1 What is a Terraform resource?

A resource is used to create and manage infrastructure.

Examples:

```hcl
resource "aws_vpc" "day3" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraweek-day3-vpc"
  }
}
```

This configuration tells Terraform to manage an AWS VPC.

## 2.2 What is a Terraform data source?

A data source reads information about existing infrastructure or available cloud resources.

For example, this data source discovers available Availability Zones:

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

This data source discovers a suitable Amazon Linux 2023 AMI:

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

### Explanation

- `owners = ["amazon"]` restricts the AMI search to images owned by Amazon.
- `most_recent = true` selects the newest image matching the filters.
- `architecture = x86_64` selects an x86-64 image.
- `virtualization-type = hvm` selects hardware virtual machine images.

The selected AMI ID is referenced by the EC2 instance using:

```hcl
ami = data.aws_ami.amazon_linux.id
```

The exact AMI returned depends on the AWS region and the images available when Terraform evaluates the data source.

## 2.3 Resources versus data sources

| Feature | Resource | Data source |
|---|---|---|
| Main purpose | Create and manage infrastructure | Read information |
| Example | `aws_instance` | `aws_ami` |
| Changes infrastructure? | Yes, according to its configuration and lifecycle | No, it reads information |
| Can be referenced by other blocks? | Yes | Yes |
| Typical use | Creating a VPC | Finding an AMI |

### Key takeaway

Resources manage infrastructure; data sources provide information that Terraform can use to configure that infrastructure.

---

# ✅ Task 3: Provision an AWS Cloud Stack

## 3.1 Understand the network architecture

The infrastructure includes a VPC, a public subnet, an Internet Gateway, a route table, a security group, and an EC2 instance.

```text
                     INTERNET
                         |
                  Internet Gateway
                         |
                   Public Route Table
                         |
              VPC: 10.0.0.0/16
                         |
              Public Subnet: 10.0.1.0/24
                         |
                  Security Group
                         |
                  EC2 Instance
                Amazon Linux 2023
                         |
                       Nginx
```

## 3.2 Understand the six building blocks

### 1. VPC

A Virtual Private Cloud provides an isolated virtual network in AWS.

Example CIDR:

```text
10.0.0.0/16
```

### 2. Subnet

A subnet is a smaller network range inside the VPC.

Example CIDR:

```text
10.0.1.0/24
```

### 3. Internet Gateway

An Internet Gateway provides a connection between the VPC and the public internet when the routing and network configuration permit it.

### 4. Route Table

A route table defines where network traffic should go.

Example default route:

```text
Destination: 0.0.0.0/0
Target: Internet Gateway
```

### 5. Security Group

A security group acts as a stateful virtual firewall for associated network interfaces.

For this exercise, the example allows HTTP traffic on TCP port 80. It does not open SSH port 22.

### 6. EC2 Instance

An EC2 instance is a virtual machine that runs the operating system and application software.

In this assignment, the instance uses an Amazon Linux 2023 AMI and can install Nginx during boot.

## 3.3 Create the AWS resources

The primary Terraform configuration in `example/main.tf` defines the following resources:

| Resource | Terraform type |
|---|---|
| VPC | `aws_vpc` |
| Public subnet | `aws_subnet` |
| Internet Gateway | `aws_internet_gateway` |
| Route table | `aws_route_table` |
| Route table association | `aws_route_table_association` |
| Security group | `aws_security_group` |
| EC2 instance | `aws_instance` |

The EC2 resource references the VPC-related resources and the AMI data source. Terraform uses these references to determine creation order.

## 3.4 Format the configuration

```bash
terraform fmt
```

This standardizes Terraform formatting.

## 3.5 Validate the configuration

```bash
terraform validate
```

Expected successful output:

```text
Success! The configuration is valid.
```

Validation checks the configuration's syntax and structure. It does not guarantee that AWS permissions, quotas, or resource creation will succeed.

## 3.6 Review the execution plan

```bash
terraform plan
```

Terraform compares the configuration with its current state and proposes infrastructure changes.

Review:

- Which resources will be created.
- Which attributes are changing.
- Which resources will be replaced.
- The configured AWS region and instance type.

Do not apply the plan if it contains unexpected resources or destructive changes.

## 3.7 Create the infrastructure

```bash
terraform apply
```

Review the plan and type `yes` when Terraform requests confirmation.

Terraform creates the resources according to the dependency graph.

**Cost note:** An EC2 instance, storage, public IPv4 usage, and other resources can incur charges. Verify the pricing and Free Tier eligibility for your AWS account before applying.

## 3.8 Inspect Terraform state

```bash
terraform state list
```

The state should contain addresses for the resources that Terraform manages, such as:

```text
aws_instance.web
aws_internet_gateway.day3
aws_route_table.public
aws_route_table_association.public
aws_security_group.web
aws_subnet.public
aws_vpc.day3
```

The exact output may differ if the configuration contains additional resources.

## 3.9 Get the EC2 public IP

If the configuration defines an output named `instance_public_ip`, run:

```bash
terraform output -raw instance_public_ip
```

Test the web server:

```bash
curl http://YOUR_PUBLIC_IP
```

Replace `YOUR_PUBLIC_IP` with the actual public IP.

If Nginx has installed successfully, the example configuration should return:

```text
Hello from TerraWeek Day 3!
```

If the response is unavailable, verify the EC2 instance status, security group rules, and boot logs.

---

# ✅ Task 4: Terraform Meta-Arguments

Meta-arguments provide additional control over how Terraform manages resources.

The four required concepts are `count`, `for_each`, `depends_on`, and `lifecycle`.

## 4.1 count

The `count` meta-argument creates a specified number of instances.

Example:

```hcl
resource "aws_s3_bucket" "count_demo" {
  count = 2

  bucket = "replace-with-your-unique-name-${count.index}"

  tags = {
    Name = "count-demo-${count.index}"
  }
}
```

Replace the bucket name prefix with a globally unique, lowercase name before applying. S3 bucket names must be unique across the applicable AWS partition.

Terraform addresses the instances using numeric indexes:

```text
aws_s3_bucket.count_demo[0]
aws_s3_bucket.count_demo[1]
```

### When should count be used?

Use `count` for resources that are mostly identical and can be treated as a numbered collection.

One drawback is that removing an item from the middle of a counted list can shift indexes and cause unnecessary changes to other instances.

This is an optional practice example and is separate from the main network stack.

## 4.2 for_each

The `for_each` meta-argument creates resources from a map or set of strings.

Example:

```hcl
variable "bucket_names" {
  default = ["frontend", "backend"]
}

resource "aws_s3_bucket" "foreach_demo" {
  for_each = toset(var.bucket_names)

  bucket = "replace-with-your-unique-name-${each.key}"

  tags = {
    Name = each.key
  }
}
```

Replace the example bucket name prefix with a unique name before applying.

Example resource addresses:

```text
aws_s3_bucket.foreach_demo["frontend"]
aws_s3_bucket.foreach_demo["backend"]
```

### When should for_each be used?

Use `for_each` when each resource has a meaningful identity.

For example, removing the `frontend` key doesn't automatically renumber the `backend` resource.

### count versus for_each

| count | for_each |
|---|---|
| Uses numeric indexes | Uses map keys or set values |
| Suitable for interchangeable resources | Suitable for named resources |
| Index shifts can cause unwanted changes | Stable keys make individual changes easier to manage |

**Important:** These S3 examples create additional resources and are not required to build the main network stack. Apply them only if you want to practice creating and managing extra AWS resources.

## 4.3 depends_on

Terraform automatically infers dependencies from resource references.

For example:

```hcl
subnet_id = aws_subnet.public.id
```

This tells Terraform that the subnet must exist before the instance can be created.

The `depends_on` meta-argument explicitly declares a dependency that cannot be inferred from an expression.

Example:

```hcl
depends_on = [
  aws_route_table_association.public
]
```

This can be placed inside the EC2 resource to ensure the route table association is created first.

Use explicit dependencies only when needed; unnecessary dependencies can make Terraform's execution more restrictive.

## 4.4 lifecycle

The `lifecycle` meta-argument changes Terraform's resource lifecycle behavior.

### create_before_destroy

```hcl
lifecycle {
  create_before_destroy = true
}
```

Terraform attempts to create a replacement before destroying the existing resource when replacement is necessary and the resource supports that behavior.

### prevent_destroy

```hcl
lifecycle {
  prevent_destroy = true
}
```

This prevents Terraform from planning destruction of the resource while the rule remains in the configuration.

It is a guardrail, not a general-purpose backup mechanism. Removing the resource configuration itself can also remove that protection.

### ignore_changes

```hcl
lifecycle {
  ignore_changes = [
    tags["LastModified"]
  ]
}
```

This tells Terraform to ignore changes to the selected tag after the resource has been created.

### replace_triggered_by

```hcl
lifecycle {
  replace_triggered_by = [
    aws_instance.web.id
  ]
}
```

This example is intended for another managed resource that should be replaced when the referenced instance changes. Do not add it to the same instance it references, because that would create an invalid self-reference.

### Lifecycle summary

| Rule | Purpose |
|---|---|
| `create_before_destroy` | Attempts to create a replacement first |
| `prevent_destroy` | Blocks planned destruction while configured |
| `ignore_changes` | Ignores selected attribute changes |
| `replace_triggered_by` | Triggers replacement based on another managed resource or attribute |

After changing lifecycle settings, check the plan before applying anything.

---

# ✅ Task 5: Update, Inspect and Destroy Infrastructure

## 5.1 Update a resource tag

For example, change the EC2 tag from:

```hcl
Environment = "learning"
```

to:

```hcl
Environment = "testing"
```

Run:

```bash
terraform plan
```

Terraform should propose a tag update, generally in place.

Apply only after reviewing the proposed change:

```bash
terraform apply
```

## 5.2 Understand in-place updates versus replacement

Terraform plans use symbols to show the proposed actions:

| Plan symbol | Meaning |
|---|---|
| `+` | Create a resource |
| `-` | Destroy a resource |
| `~` | Update a resource in place |
| `-/+` | Destroy and recreate a resource |
| `<=` | Read a data source |

Changing an EC2 tag typically results in an in-place update. Changing the AMI usually requires a replacement. Changing an instance type commonly updates the existing instance in place, although operational details depend on the provider and resource.

Always inspect the plan rather than assuming a change will be in place.

## 5.3 Inspect the dependency graph

Run:

```bash
terraform graph
```

This outputs a graph representation in DOT format.

To save the graph:

```bash
terraform graph > graph.dot
```

If Graphviz is installed, you can render it as an image:

```bash
dot -Tpng graph.dot -o graph.png
```

The graph helps visualize dependencies between Terraform resources and data sources.

## 5.4 Destroy test infrastructure

After finishing the exercises, inspect the planned deletion:

```bash
terraform plan -destroy
```

Ensure that the plan contains only the resources intended for removal. Remove any `prevent_destroy` rule that blocks destruction of your test resources.

Then run:

```bash
terraform destroy
```

Type `yes` after reviewing the plan.

Finally, verify the Terraform state:

```bash
terraform state list
```

If all resources managed by this configuration have been destroyed, their resource addresses should no longer appear in the state.

Check the AWS Console for resources created manually or managed outside this configuration.

---

# 📸 Screenshots and Evidence

<img width="1487" height="655" alt="Screenshot 2026-10-15 154242" src="https://github.com/user-attachments/assets/e698ff70-bfbe-471c-98ac-eee9377498b8" />
<img width="1483" height="700" alt="Screenshot 2026-10-15 154256" src="https://github.com/user-attachments/assets/e1ac806f-7431-47f6-97d5-d24fa91a7a91" />
<img width="1919" height="868" alt="Screenshot 2026-10-15 154633" src="https://github.com/user-attachments/assets/3f94ea6d-cb51-4a6b-8bb5-09f3632a5743" />

Only include evidence from operations you actually completed.

---

# 🔐 Security and Cost Best Practices

- Never hard-code AWS credentials in Terraform code.
- Do not commit secret-bearing files or Terraform state.
- Review all plans before applying or destroying resources.
- Avoid opening SSH or other administrative ports to the entire internet.
- Use least-privilege IAM permissions.
- Confirm the AWS region and account before deployment.
- Review AWS pricing, quotas, and Free Tier eligibility.
- Destroy test resources when finished.
- Check for leftover volumes, public IPv4 addresses, and other billable resources.

Example `.gitignore` entries:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
!*.tfvars.example
crash.log
```

Keep `.terraform.lock.hcl` in Git to preserve provider selections. Review any exception to the ignore rules carefully before committing.

---

# 🧠 Key Learnings

By working through Day 03, I developed an understanding of:

- How Terraform providers connect to cloud platforms.
- Why provider version constraints matter.
- How resources and data sources serve different purposes.
- How networking components work together inside AWS.
- How an EC2 instance can be provisioned with Terraform.
- How `count` and `for_each` manage collections of resources.
- How `depends_on` establishes explicit dependencies.
- How lifecycle rules influence resource updates and replacement.
- How to interpret Terraform plans and inspect state.
- Why infrastructure cleanup is important for cost control.

## 🏁 Conclusion

Day 03 provided practical experience with Terraform and AWS, progressing from provider configuration to cloud infrastructure management.

Understanding resources, data sources, dependency management, meta-arguments, and the Terraform lifecycle is an important foundation for building reliable and repeatable cloud infrastructure.

This exercise supports my ongoing DevOps learning journey and helps strengthen my Infrastructure as Code skills.

## 🙏 Acknowledgements

Thank you to **Shubham Londhe** and the **TrainWithShubham community** for organizing the TerraWeek Challenge and providing learning opportunities through practical Terraform assignments.

**Challenge:** TerraWeek Day 03  
**Focus:** Terraform Providers, Resources, Data Sources, Meta-Arguments and AWS Infrastructure

#TerraWeek #TerraWeekChallenge #Terraform #AWS #DevOps #InfrastructureAsCode #CloudComputing #TrainWithShubham
