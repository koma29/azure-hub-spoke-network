# Azure Hub-and-Spoke Network

## Overview
This project demonstrates a simple hub-and-spoke network architecture in Azure using Terraform. It is based on Microsoft Azure reference architecture guidance for centralized network design, workload isolation, and secure connectivity.

## Architecture
- Hub virtual network
- Spoke virtual network
- Subnet in each VNet
- Bidirectional VNet peering
- Network Security Groups (NSGs) applied to each subnet
- Explicit NSG rules to control hub-to-spoke and spoke-to-hub communication

## Technologies Used
- Terraform
- Azure Virtual Network (VNet)
- Azure Subnets
- Azure VNet Peering
- Azure Network Security Groups (NSGs)
- Git & GitHub

## Design Goals
- Centralize shared network functionality in the hub
- Isolate workload resources in the spoke
- Enable private connectivity between networks
- Apply subnet-level security controls

## How It Works
1. Terraform deploys a resource group
2. A hub VNet and subnet are created
3. A spoke VNet and subnet are created
4. Peering is configured between the hub and spoke VNets
5. NSGs are attached to both subnets
6. Security rules explicitly allow hub-spoke communication

## Learning Outcomes
- Built a hub-and-spoke Azure network architecture
- Used Terraform to define and deploy network resources
- Configured VNet peering for private communication
- Applied subnet-level security controls with NSGs
- Practiced Microsoft-aligned cloud architecture patterns