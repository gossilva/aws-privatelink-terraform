# 📗 **modules/network/**

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
| `aws_vpc_endpoint_service`        | Publishes NLB via PrivateLink               |
| `aws_ssm_parameter`               | Stores service name                         |

### **Outputs**

* Subnet IDs
* VPC ID
* (VPC1 only) PrivateLink service name