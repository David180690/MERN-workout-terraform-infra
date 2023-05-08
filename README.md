# MERN-workout-terraform-infra
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
