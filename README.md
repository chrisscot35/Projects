# Projects
# Secure and Scalable Multi-Tier VPC Foundation

AWS 3-Tier VPC Architecture (Terraform)
This repository provisions a 3-tier AWS VPC architecture using Terraform, consisting of public, application, and database tiers across two Availability Zones.

# Architecture Overview
# Network Layout
- VPC: 10.0.0.0/16
- Availability Zones: 2
- Tiers:
Public tier – Internet-facing resources & NAT Gateway
Application tier – Private subnets with outbound internet via NAT
Database tier – Private subnets with controlled access

# Subnets
Tier	AZ	CIDR
Public	AZ-A	10.0.2.0/24
Public	AZ-B	10.0.0.0/24
App	AZ-A	10.0.1.0/24
App	AZ-B	10.0.10.0/24
DB	AZ-A	10.0.20.0/24
DB	AZ-B	10.0.30.0/24

# Routing
Internet Gateway
- Attached to the VPC
- Used by public subnets

# NAT Gateway

- Deployed in public_a
- Provides outbound internet access for app & DB subnets

# Route Tables
Route Table	Target	        Usage
Public	   0.0.0.0/0 → IGW	Public subnets
App Private	0.0.0.0/0 → NAT	App subnets
DB Private	0.0.0.0/0 → NAT	DB subnets

#  Security
Security Groups
Security Group	Purpose
public_sg	Entry point for public tier
app_sg	Application tier access
db_sg	Database tier access
bastion_sg	SSH access to bastion host

# Security Group Rules
- Public → App: HTTPS (443)
- App → DB: PostgreSQL (5432)
- DB → Internet: All outbound allowed
- Bastion: SSH from trusted IP only

# Network ACLs
App NACL
- Inbound HTTPS (443) from VPC
- Outbound ephemeral ports

# DB NACL
- Inbound PostgreSQL (5432) from VPC
- Outbound ephemeral ports

# Bastion Host
- Instance type: t3.micro
- AMI: Amazon Linux
- Subnet: Public
- Access: SSH from a single trusted IP

# Resources Created
- VPC
- Internet Gateway
- NAT Gateway + Elastic IP
- 6 Subnets (2 per tier)
- 3 Route Tables
- 6 Route Table Associations
- 4 Security Groups
- Security Group Rules
- Network ACLs
- Bastion EC2 Instance

# Usage
- Prerequisites
- Terraform ≥ 1.5
- AWS CLI configured
- Valid AWS credentials
