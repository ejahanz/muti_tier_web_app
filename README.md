// README.md
# AWS Multi-Tier Web Application (Terraform Project)

This project provisions a **multi-tier web application** infrastructure on AWS using **Terraform** and automates deployment via **GitHub Actions**.

## 🧱 Architecture Overview

```
Users --> Route53 (optional) --> ALB --> Auto Scaling Group (EC2 Web Tier)
                               |
                               --> RDS (MySQL DB - Private Subnet)

Networking:
- VPC with Public and Private Subnets across 2 AZs
- NAT Gateway for outbound internet from private subnets

Security:
- Public subnets for load balancer and EC2 web servers
- Private subnets for database
- Security groups for tiered access
```

## 🚀 Features
- VPC + 2-tier subnet structure
- Auto Scaling Group for EC2 Web Tier
- RDS MySQL instance in private subnet
- Secure networking and IAM best practices
- GitHub Actions CI/CD Pipeline for Terraform

## 🔧 Prerequisites
- AWS account with IAM credentials
- GitHub repository with `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` set as secrets
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- [GitHub CLI](https://cli.github.com/) (optional)

## 📁 How to Use
1. **Clone the repo**
```bash
git clone https://github.com/your-username/aws-multi-tier-app.git
cd aws-multi-tier-app
```

2. **Customize the variables**
Update `terraform.tfvars` with your desired values.

3. **Initialize Terraform**
```bash
terraform init
```

4. **Plan and Apply**
```bash
terraform plan
terraform apply
```

5. **GitHub Actions Pipeline**
Push changes to the `main` branch to trigger CI/CD:
```bash
git add .
git commit -m "Deploy infra"
git push origin main
```

## 📌 Notes
- The RDS password is stored in `terraform.tfvars`. **Do not commit this file.**
- State files are local. You can configure an S3 backend for remote state storage.

## 🛠 Tech Stack
- AWS (VPC, EC2, RDS, ALB, IAM)
- Terraform
- GitHub Actions

---

Feel free to fork and extend this infrastructure by adding Route53, SSL via ACM, ECS for containers, or CloudFront!
