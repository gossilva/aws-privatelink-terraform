# 📙 **modules/compute/**

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