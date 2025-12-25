# Task 2: AWS Infrastructure as Code (Production-Ready)

This section describes the Infrastructure as Code (IaC) used to deploy the application on AWS in a secure, scalable, and production-ready manner using Terraform.

---

## Overview of Infrastructure Design

The infrastructure is designed using AWS managed services and follows cloud best practices such as network isolation, least privilege, and high availability.

### High-Level Architecture

```
Internet
   |
   v
Application Load Balancer (Public Subnets, HTTPS)
   |
   v
ECS Fargate Service (Private Subnets, No Public IPs)
   |
   v
RDS PostgreSQL (Private Subnets, Multi-AZ)
```

The infrastructure is provisioned using **Terraform with a modular structure**, separating networking, compute, load balancing, database, and security concerns.

---

## Why These AWS Services Were Chosen

### Amazon VPC
- Provides full network isolation
- Enables separation of public and private workloads
- Required for enterprise-grade security

### Application Load Balancer (ALB)
- Acts as the single public entry point
- Terminates HTTPS using ACM certificates
- Performs health checks
- Eliminates the need for an Nginx reverse proxy in production

### Amazon ECS Fargate
- Serverless container orchestration (no EC2 management)
- Ideal for stateless backend services
- Native integration with ALB
- Supports rolling deployments and auto-scaling

### Amazon RDS (PostgreSQL)
- Fully managed relational database
- Multi-AZ for high availability
- Automated backups and patching
- Avoids risks of running stateful databases in containers

### AWS Secrets Manager
- Secure storage for database credentials
- Secrets are injected at runtime into ECS tasks
- No secrets stored in Git or Terraform state

### Terraform
- Declarative Infrastructure as Code
- Enables repeatable and auditable deployments
- Modular design improves maintainability and reuse

---

## How to Deploy (Illustrative Commands)

> These commands demonstrate the deployment flow. 

### Prerequisites
- AWS account
- AWS CLI configured
- Terraform installed
- Docker image available in ECR (or CI/CD pipeline configured)

### Deployment Steps

```bash
cd terraform/

terraform init
terraform validate
terraform plan
terraform apply
```

After deployment, Terraform outputs the **Application Load Balancer DNS name**, which can be used to access the application over HTTPS.

---

## Security Considerations Implemented

- No public IPs on ECS tasks or RDS instances
- Private subnets used for backend and database
- Least-privilege security group rules:
  - ALB → ECS only
  - ECS → RDS only
- Database credentials stored in AWS Secrets Manager
- Secrets injected at runtime (not hardcoded)
- HTTPS enforced at the ALB level
- IAM roles scoped only to required permissions
- Stateless containers to reduce attack surface

---

## Assumptions

- An ACM certificate already exists for HTTPS
- A Route53 hosted zone exists if a custom domain is required
- Terraform remote state (S3 + DynamoDB) can be added for team usage
- CI/CD pipeline handles Docker image builds and ECS deployments

---

## Trade-offs and Design Decisions

### ECS Fargate vs EC2
- **Chosen:** ECS Fargate  
- **Trade-off:** Higher cost per vCPU but no server management and improved reliability

### RDS vs Containerized Database
- **Chosen:** RDS PostgreSQL  
- **Trade-off:** Higher cost in exchange for backups, failover, and operational safety

### ALB vs Nginx Container
- **Chosen:** ALB  
- **Trade-off:** Less custom routing flexibility but superior scalability, security, and AWS integration

### Cost vs Availability
- Multi-AZ RDS increases cost but ensures high availability
- NAT Gateway adds cost but allows secure internet access from private subnets

---

