# 🏗️ **AWS PrivateLink Terraform Project**

## 📘 Overview

This Terraform project implements a **PrivateLink architecture** between two isolated AWS VPCs using modular design:

* **VPC1 (Provider)** hosts an internal service behind an **NLB (Network Load Balancer)** exposed via a **VPC Endpoint Service**.
* **VPC2 (Consumer)** connects privately to that service through an **Interface VPC Endpoint**, retrieving the service name automatically via **AWS Systems Manager (SSM) Parameter Store**.

Both VPCs follow the same modular structure:

```
vpc1/
 ├── modules/
 │   ├── network/
 │   │      ├── igw.tf
 │   │      ├── ngw.tf
 │   │      ├── output.tf
 │   │      ├── private.tf
 │   │      ├── public.tf
 │   │      ├── region.tf
 │   │      ├── service-ssm-parameter
 │   │      ├── variables.tf
 │   │      ├── vpc.tf
 │   │      └── vpce-service.tf
 │   └── compute/
 │          ├── alb-sg.tf
 │          ├── alb.tf
 │          ├── output.tf
 │          ├── asg-sg.tf
 │          ├── asg.tf
 │          ├── nlb.tf
 │          ├── userdata.sh
 │          └── variables.tf 
 ├── locals.tf
 ├── modules.tf
 ├── provider.tf
 └── variables.tf

vpc2/
 ├── modules/
 │   ├── network/
 │   │      ├── igw.tf
 │   │      ├── ngw.tf
 │   │      ├── output.tf
 │   │      ├── private.tf
 │   │      ├── public.tf
 │   │      ├── region.tf
 │   │      ├── variables.tf
 │   │      ├── vpc.tf
 │   │      └── vpce.tf
 │   └── compute/
 │          ├── ec2.tf
 │          ├── instance-profile.tf
 │          └── variables.tf 
 ├── locals.tf
 ├── modules.tf
 ├── provider.tf
 └── variables.tf
```

---


```

---

## ⚙️ Project Execution Flow

| Step | Action                         | Directory         | Description                                                                                     |
| ---- | ------------------------------ | ----------------- | ----------------------------------------------------------------------------------------------- |
| 1️⃣  | Initialize and deploy **VPC1** | `vpc1/`           | Creates provider VPC, subnets, NAT, ALB, NLB, ASG, and publishes the PrivateLink service to SSM |
| 2️⃣  | Initialize and deploy **VPC2** | `vpc2/`           | Creates consumer VPC, subnets, NAT, EC2 instance with SSM, and connects to the PrivateLink      |
| 3️⃣  | Verify connection              | AWS Console / CLI | Test EC2 instance communication via PrivateLink                                                 |
| 4️⃣  | (Optional) Destroy             | Each VPC folder   | Safely remove all resources                                                                     |

---

##  Deployment Instructions

### **1. Clone Repository**

```bash
git clone https://github.com/gossilva/aws-privatelink-terraform.git
cd aws-privatelink-terraform
```

### **2. Deploy VPC1**

```bash
cd vpc1
terraform init
terraform plan
terraform apply -auto-approve
```

### **3. Deploy VPC2**

After VPC1 is successfully applied:

```bash
cd ../vpc2
terraform init
terraform plan
terraform apply -auto-approve
```

> ⚠️ Ensure both VPCs are in the same AWS Region (default: `us-east-1`).

### **4. Destroy Environment**

```bash
cd vpc2 && terraform destroy -auto-approve
cd ../vpc1 && terraform destroy -auto-approve
```

---

## 🧠 Tagging & Environment Context

Each VPC uses its own `locals.tf` for consistent tagging:

### **VPC1**

```hcl
locals {
  tags = {
    Department    = "Networking"
    Organization  = "Infrastructure and Operations"
    Project       = "PrivateLink"
    Environment   = "Development"
  }
}
```

### **VPC2**

```hcl
locals {
  tags = {
    Department    = "Fintech"
    Organization  = "Finances and Marketplace"
    Project       = "Banking Application"
    Environment   = "Production"
  }
}
```

These tags propagate automatically to all resources via `local.tags`.

---

## 🪶 Backend State Configuration

Each VPC is designed to support **separate remote states** (for scalability and modular independence).

Example (currently commented in `provider.tf`):

```hcl
backend "s3" {
  bucket = "vpc1-state"
  key    = "path/to/vpc1"
  region = "us-east-1"
}
```

and

```hcl
backend "s3" {
  bucket = "vpc2-state"
  key    = "path/to/vpc2"
  region = "us-east-1"
}
```

---

## 🧱 Modules

### **vpc1/modules/network/**

Creates VPC1’s core infrastructure:

* VPC, subnets, route tables, IGW, NAT
* Public & Private subnets across AZs
* PrivateLink **VPC Endpoint Service** with NLB
* Stores service name in **SSM Parameter Store**

---

### **vpc1/modules/compute/**

Creates application layer:

* ALB + ASG (with Launch Template)
* NLB for PrivateLink exposure
* EC2 UserData startup script (`userdata.sh`)
* Security Groups for both ALB and ASG

---

### **vpc2/modules/network/**

Creates client-side VPC:

* VPC, subnets, IGW, NAT, route tables
* **Interface VPC Endpoint** connecting to VPC1’s service via SSM

---

### **vpc2/modules/compute/**

Creates EC2 instance with IAM role and SSM access:

* EC2 with `AmazonSSMManagedInstanceCore`
* Instance Profile with minimal trust policy
* Allows remote management via AWS Systems Manager

---

# 📗 **modules/network/README.md**

### **Purpose**

Defines the full AWS networking layer for the VPC — subnets, routing, and endpoint connectivity.

### **Main Resources**

| Resource                          | Description                                 |
| --------------------------------- | ------------------------------------------- |
| `aws_vpc`                         | Base VPC with DNS support enabled           |
| `aws_subnet`                      | Public and private subnets across AZs       |
| `aws_internet_gateway`            | Internet access for public subnets          |
| `aws_nat_gateway`                 | Outbound access for private subnets         |
| `aws_route_table` / `association` | Route management for subnet traffic         |
| `aws_vpc_endpoint_service` (VPC1) | Publishes NLB via PrivateLink               |
| `aws_vpc_endpoint` (VPC2)         | Consumes service through Interface Endpoint |
| `aws_ssm_parameter`               | Stores or retrieves service name            |

### **Outputs**

* Subnet IDs
* VPC ID
* (VPC1 only) PrivateLink service name

---

# 📙 **modules/compute/README.md**

### **Purpose**

Implements the compute layer (application servers, load balancers, and autoscaling).

### **Main Resources**

| Resource                                | Description                                        |
| --------------------------------------- | -------------------------------------------------- |
| `aws_lb` (ALB + NLB)                    | Public-facing ALB and internal NLB for PrivateLink |
| `aws_autoscaling_group`                 | Auto-scaling EC2 group with launch template        |
| `aws_security_group`                    | Ingress/Egress rules between ALB, ASG, and NLB     |
| `aws_launch_template`                   | Defines EC2 startup config (AMI, UserData)         |
| `aws_instance` (VPC2)                   | Single SSM-managed EC2                             |
| `aws_iam_role` / `aws_instance_profile` | Grants EC2 SSM access                              |

### **UserData Example**

```bash
#!/bin/bash
yum update -y
yum install -y httpd
echo "<h1>Servidor iniciado via Terraform</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
```

---

# 🚀 **Key Features**

✅ Modular and reusable Terraform structure
✅ Multi-VPC design using PrivateLink
✅ Automatic cross-VPC connection via SSM Parameter Store
✅ Full tagging standardization with locals
✅ Easily extensible to multi-region or multi-account setups

---

# 🧩 **Example Execution Order**

```bash
# Deploy Provider VPC
cd vpc1
terraform init && terraform apply -auto-approve

# Deploy Consumer VPC
cd ../vpc2
terraform init && terraform apply -auto-approve
```

---

# 📄 **License**

MIT License — freely reusable and modifiable for educational or production environments.
