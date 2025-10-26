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

## 🗺️ Architecture Diagram

![AWS PrivateLink Architecture Diagram](https://raw.githubusercontent.com/<teu-usuario>/<repo>/main/aws-privatelink-terraform/diagram/aws-private-link.png)

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

## Backend State Configuration

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
