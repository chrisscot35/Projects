# Projects
# Secure and Scalable Multi-Tier VPC Foundation

## Architecture Diagram
graph TD
  Internet --> ALB
  ALB --> AppTier
  AppTier --> DataTier
  Bastion --> AppTier

  Design Overview

This VPC architecture is a standard three-tier model designed for high availability, security, and scalability.

High Availability

Two Availability Zones

Subnets replicated per AZ

Network Segmentation

Public Subnets: ALB, Bastion

Private App Subnets: Application workloads

Private Data Subnets: Databases

Routing

Internet Gateway for public traffic

NAT Gateway for private outbound access

Security Controls

Security Groups enforce tier-to-tier communication

Network ACLs add subnet level enforcement

Bastion host enables controlled administrative access

Traffic Rules

Internet → Public (443)

Public → App (443)

App → Data (DB port only)

No direct internet access to App or Data tiers

Outcome

This foundation provides a secure, compliant, and scalable base suitable for production workloads and regulated environments.


---

# 4.This Is Production Grade

✔ Multi-AZ resilience  
✔ Defense-in-depth (SG + NACL)  
✔ Least-privilege networking  
✔ Secure admin access via bastion  
✔ Clear separation of tiers  
✔ Fully automated with IaC  

----