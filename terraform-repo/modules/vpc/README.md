# Terraform AWS VPC Project

## Overview

This project demonstrates how to use **Terraform** to provision an AWS Virtual Private Cloud (VPC) in a production-like environment. It follows best practices for Infrastructure as Code (IaC), including modular design, remote state management, and environment separation (prod vs sandbox). The focus is on creating a highly available VPC with public and private subnets, Internet Gateway, NAT Gateways, and route tables.

This README serves as a learning guide:
- Explains key AWS VPC concepts.
- Notes important points for the AWS Certified Solutions Architect - Associate (SAA-C03) exam related to VPC.
- Highlights key Terraform concepts used in this lab.
- Details the file structure, variables, and how they interconnect.

The project assumes you have an AWS account, Terraform installed, and AWS CLI configured with credentials. Run commands from the `environments/prod/` directory for production setup.

## AWS VPC Concepts

A **Virtual Private Cloud (VPC)** is a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. It provides control over your virtual networking environment, including IP address ranges, subnets, route tables, and network gateways.

### Key Concepts (Learning Notes)
- **VPC Basics**: 
  - A VPC spans all Availability Zones (AZs) in a region. You define a CIDR block (e.g., `10.0.0.0/16`) for IP addressing. Avoid overlapping CIDRs when peering or connecting VPCs.
  - Default VPC: AWS provides one per region, but for production, create custom VPCs for better control.

- **Subnets**:
  - Subdivisions of the VPC CIDR. Each subnet is in one AZ for high availability.
  - **Public Subnet**: Has a route to the internet via an Internet Gateway. Instances get public IPs if enabled (`map_public_ip_on_launch = true`).
  - **Private Subnet**: No direct internet access. Use NAT Gateway for outbound traffic.

- **Internet Gateway (IGW)**:
  - Attaches to the VPC and enables internet access for public subnets. Scalable and highly available.

- **NAT Gateway**:
  - Allows private subnets to access the internet (outbound) without exposing them. Deploy in public subnets (one per AZ for HA). Requires Elastic IP (EIP).
  - Alternative: NAT Instance (cheaper but less managed).

- **Route Tables**:
  - Control traffic routing within the VPC. Associate with subnets.
  - Public route: `0.0.0.0/0` to IGW.
  - Private route: `0.0.0.0/0` to NAT Gateway.

- **Security**:
  - **Security Groups**: Stateful firewalls at instance level (allow rules only).
  - **Network ACLs (NACLs)**: Stateless firewalls at subnet level (allow/deny rules).
  - Not implemented in this lab but crucial for production.

- **Advanced Features**:
  - VPC Peering: Connect two VPCs (non-transitive).
  - VPC Endpoints: Private access to AWS services (e.g., S3 Gateway Endpoint).
  - Flow Logs: Monitor network traffic for analysis.

These concepts are foundational for building secure, scalable networks on AWS. In this lab, we implement a basic HA VPC with 2 public and 2 private subnets across 2 AZs.

## SAA-C03 Exam Notes on VPC

The AWS Certified Solutions Architect - Associate (SAA-C03) exam covers VPC extensively under domains like "Design Secure Architectures" and "Design Resilient Architectures." Expect questions on designing VPCs for high availability, security, and connectivity.

### Key Exam Topics and Notes
- **VPC Design and Subnets** (High Frequency):
  - Understand CIDR notation and non-overlapping ranges for multi-VPC setups.
  - Public vs Private subnets: Public for ELBs/ALBs, private for EC2/RDS. Ensure HA by spreading across AZs.
  - Exam Tip: Calculate subnet sizes (e.g., /24 for 256 IPs) and avoid common errors like overlapping CIDRs.

- **Gateways and Routing**:
  - Internet Gateway: Required for public internet access; one per VPC.
  - NAT Gateway: For private subnet outbound (e.g., software updates). Place in public subnet; use one per AZ for fault tolerance.
  - Route Tables: Custom routes for IGW/NAT. Main route table is default; associate explicitly.
  - Exam Scenario: Troubleshooting no internet access? Check routes, IGW attachment, and public IP assignment.

- **Connectivity Options**:
  - VPC Peering: For VPC-to-VPC communication (same/different accounts/regions). Non-transitive; update routes manually.
  - AWS Direct Connect: Dedicated private connection from on-premises to AWS (bypasses internet).
  - Site-to-Site VPN: Encrypted connection over internet; uses Virtual Private Gateway.
  - Transit Gateway: Hub for scaling multiple VPC/on-prem connections.
  - Exam Tip: Choose based on bandwidth/security: Direct Connect for low-latency, VPN for quick setup.

- **Security and Monitoring**:
  - Security Groups vs NACLs: SG is instance-level (stateful), NACL subnet-level (stateless). SG default allow outbound; NACL default allow all.
  - VPC Flow Logs: Capture IP traffic for analysis (store in S3/CloudWatch).
  - Endpoints: Interface (powered by PrivateLink) for services like EC2 API; Gateway for S3/DynamoDB (free).
  - Exam Scenario: Secure access to S3 without internet? Use VPC Gateway Endpoint.

- **Best Practices for SAA**:
  - HA: Multi-AZ subnets, redundant NATs.
  - Cost: NAT Gateway is charged per hour/GB; optimize with NAT Instances if low traffic.
  - Limits: 5 VPCs per region (soft limit); 200 subnets per VPC.
  - Common Questions: Hybrid networking (VPN/Direct Connect), peering limitations, troubleshooting connectivity.

**Study Resources**: AWS VPC documentation, SAA-C03 exam guide (domains 1-4 cover ~30% networking). Practice with sample questions on peering, routing, and security.

## Terraform in This Lab: Key Notes

While building this VPC lab, we applied Terraform principles for IaC. Terraform manages AWS resources declaratively, ensuring reproducibility and version control.

### Key Terraform Concepts Used
- **Provider**: Configures AWS connection (`provider "aws" { region = var.region }`). Version pinned for stability.
- **Resources**: Define AWS objects, e.g., `aws_vpc`, `aws_subnet`, `aws_nat_gateway`. Uses loops (`count`) for multiple subnets/AZs.
- **Modules**: Reusable code block (`modules/vpc/`). Called from `environments/prod/main.tf` with inputs.
- **Variables**: Input parameters for customization (defined in `variables.tf`, values in `terraform.tfvars`).
- **Outputs**: Export values like `vpc_id` for use in other modules or queries.
- **Backend**: Remote state on S3 with DynamoDB locking for team collaboration and safety.
- **Workflow**: `terraform init` (initialize), `plan` (preview), `apply` (create), `destroy` (cleanup).
- **Best Practices in Lab**:
  - Modular structure separates concerns.
  - Uses `tags` for resource naming (e.g., `Name = "${var.environment}-vpc"`).
  - HA with multi-AZ.
  - Run `terraform validate` and `terraform fmt` for consistency.
  - Minimal IAM permissions; no hard-coded secrets.

### Notes from Lab Execution
- **Dynamic Resources**: Used `count` for subnets/NATs (e.g., `count = length(var.public_subnet_cidrs)`).
- **Dependencies**: Terraform auto-detects (e.g., subnet created before route association).
- **Error Handling**: CIDR overlap causes plan failure—validate IPs early.
- **Cost Awareness**: NAT Gateways incur charges (~$0.045/hour per NAT). Run `terraform destroy` after lab.
- **Debugging**: Use `terraform plan -out=plan.tfplan` for safe previews.
- **Production Tip**: Integrate with CI/CD (e.g., GitHub Actions) for automated applies; consider workspaces for simpler env management.

## File Structure and Variables Explanation

The project is structured modularly for scalability. Root files handle global config; `modules/` for reusable components; `environments/` for env-specific calls.

### Directory Structure
```
├── environments/
│   ├── prod/
│   │   ├── main.tf           # Calls VPC module
│   │   ├── variables.tf      # Defines variables (schema, types, descriptions)
│   │   ├── outputs.tf        # Exports from module
│   │   └── terraform.tfvars  # Specific values for prod
│   └── sandbox/              # Similar for sandbox (not detailed here)
├── modules/
│   └── vpc/
│       ├── main.tf           # Core VPC resources
│       ├── variables.tf      # Module-specific inputs
│       ├── outputs.tf        # Module exports
│       └── README.md         # Module docs (optional)
├── backend.tf                # Remote state config (S3 + DynamoDB)
├── provider.tf               # AWS provider setup
└── README.md                 # This file
```

### Variables Explanation and Linkages
Variables promote reusability: Defined once, valued per environment, passed to modules.

1. **`region`** (string):
   - **Defined**: `environments/prod/variables.tf` (`type = string`, no default to enforce explicit value).
   - **Assigned**: `environments/prod/terraform.tfvars` (`region = "us-west-2"`).
   - **Used**: `provider.tf` (`provider "aws" { region = var.region }`).
   - **Link**: Sets AWS region for all resources. Must match `availability_zones` (e.g., `us-west-2a` is valid in `us-west-2`).

2. **`vpc_cidr`** (string):
   - **Defined**: `environments/prod/variables.tf` and `modules/vpc/variables.tf`.
   - **Assigned**: `terraform.tfvars` (`vpc_cidr = "10.0.0.0/16"`).
   - **Passed**: `environments/prod/main.tf` (`module "vpc" { vpc_cidr = var.vpc_cidr }`).
   - **Used**: `modules/vpc/main.tf` (`aws_vpc.main { cidr_block = var.vpc_cidr }`).
   - **Link**: Defines VPC IP range. Subnets (`public_subnet_cidrs`, `private_subnet_cidrs`) must be subsets (e.g., /24 within /16).

3. **`public_subnet_cidrs`** (list(string)):
   - **Defined**: `variables.tf` and module.
   - **Assigned**: `terraform.tfvars` (`["10.0.1.0/24", "10.0.2.0/24"]`).
   - **Passed**: To module in `main.tf`.
   - **Used**: `aws_subnet.public` (loop: `cidr_block = var.public_subnet_cidrs[count.index]`).
   - **Link**: Creates public subnets. Length determines number of subnets and route table associations. Must align with `availability_zones` length.

4. **`private_subnet_cidrs`** (list(string)):
   - **Similar**: To `public_subnet_cidrs`. Used for private subnets, linked to NAT Gateways via private route tables.
   - **Link**: Each private subnet routes to a NAT Gateway in the corresponding public subnet (same AZ).

5. **`availability_zones`** (list(string)):
   - **Defined/Assigned**: `variables.tf`/`tfvars` (`["us-west-2a", "us-west-2b"]`).
   - **Used**: `aws_subnet.public/private` (`availability_zone = var.availability_zones[count.index]`).
   - **Link**: Ensures HA by distributing subnets across AZs. Length must match subnet CIDR lists to avoid errors.

6. **`environment`** (string):
   - **Defined**: `modules/vpc/variables.tf`.
   - **Passed**: Hard-coded in `main.tf` (`environment = "prod"`).
   - **Used**: Tags (e.g., `Name = "${var.environment}-vpc"`).
   - **Link**: Differentiates resources (prod vs sandbox) for filtering in AWS Console or cost explorer.

### How Variables Interconnect
- **Flow**: Variables are defined in `variables.tf` → assigned in `terraform.tfvars` → passed to module in `main.tf` → used in module resources → outputs exported (`outputs.tf`).
- **Dependencies**: Subnet CIDRs depend on `vpc_cidr`. AZs control loop counts for subnets/NATs. Outputs (`vpc_id`, `subnet_ids`) feed into future modules (e.g., EC2).
- **Overrides**: `terraform.tfvars` takes precedence over any defaults in `variables.tf` (none used here for safety).
- **Validation**: Types (`list(string)`) enforce correctness. Could add `validation` blocks for CIDR checks.

## Getting Started
1. Create S3 bucket (`my-terraform-state-bucket`) and DynamoDB table (`terraform-state-lock`, partition key: `LockID`).
2. `cd environments/prod`
3. `terraform init`
4. `terraform plan`
5. `terraform apply`
6. Verify in AWS Console (VPC, subnets, NAT Gateways).
7. `terraform destroy` to avoid charges (e.g., NAT Gateway).

## Next Steps
- Extend with modules for EC2, RDS, or ELB using exported subnet IDs.
- Test in sandbox (duplicate `prod/` folder, adjust `tfvars`).
- SAA Prep: Practice scenarios like "Enable private EC2 internet access" (NAT Gateway) or "Secure S3 access" (VPC Endpoint).
- CI/CD: Add GitHub Actions for automated plan/apply.

For issues, check Terraform logs or AWS Console. Reach out for further extensions!