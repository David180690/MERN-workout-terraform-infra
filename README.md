# MERN-workout-terraform-infra-study branch

source for mern: https://www.youtube.com/watch?v=98BzS5Oz5E4&list=PL4cUxeGkcC9iJ_KkrkBZWZRHVwnzLIoUE


To start, we need to identify the components of your application and determine the resources required to run it on AWS. From your GitHub repo, it seems like your application is a MERN (MongoDB, Express, React, Node.js) stack workout tracker.

Here are some resources that you might need to deploy your application on AWS:

Virtual Private Cloud (VPC) - This will provide the networking infrastructure for your application.

Subnets - These are logical partitions of a VPC that allow you to segment your resources.

Internet Gateway - This will allow your resources in the private subnets to access the internet.

Elastic Container Service (ECS) or Elastic Kubernetes Service (EKS) - These are container orchestration services that allow you to run Docker containers on AWS.

Elastic Load Balancer (ELB) - This will distribute traffic to your containers running in ECS or EKS.

Relational Database Service (RDS) - This is a managed database service that you can use to host your MongoDB instance.

Elastic File System (EFS) - This is a managed file system that you can use to share files across your containers.

Once we have identified the required resources, we can start creating the Terraform code to provision them. We can also create a Docker Compose file to define the services and their dependencies.

Let me know if this makes sense, and we can proceed with creating the Terraform code and Docker Compose file.



This Terraform code creates an Amazon Elastic Kubernetes Service (EKS) cluster with a Managed Node Group and an NAT Gateway. The code provisions resources in the AWS eu-central-1 region. Here's what the code does:

Creates a VPC with a /16 IP address range (10.0.0.0/16).
Creates two subnets in different availability zones, one of which is designated as a public subnet. The subnets use /24 IP address ranges (10.0.1.0/24 and 10.0.2.0/24).
Creates an Internet Gateway and attaches it to the VPC.
Creates a route table and adds a default route to the Internet Gateway. Associates the route table with the public subnet.
Creates a security group that allows incoming SSH traffic (port 22) from any IP address.
Creates an IAM role for the EKS cluster to use.
Attaches the AmazonEKSClusterPolicy to the IAM role.
Creates the EKS cluster with a specified name and VPC configuration. Uses the IAM role created earlier.
Creates an IAM role for the EKS nodes to use.
Attaches the AmazonEKSWorkerNodePolicy and AmazonEC2ContainerRegistryReadOnly policies to the IAM role.
Creates a Managed Node Group in the EKS cluster. The Managed Node Group uses the IAM role created earlier and is launched in the public subnet.
Creates an Elastic IP address and a NAT Gateway in the public subnet. The NAT Gateway uses the Elastic IP address as its public IP address.
