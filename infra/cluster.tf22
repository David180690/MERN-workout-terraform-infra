provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "eks_vpc_cluster_mern" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "my_igw_mern" {
  vpc_id = aws_vpc.eks_vpc_cluster_mern.id
}

resource "aws_route_table" "my_route_table_mern" {
  vpc_id = aws_vpc.eks_vpc_cluster_mern.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw_mern.id
  }
  
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.eks_subnet_cluster_mern.id
  route_table_id = aws_route_table.my_route_table_mern.id
}



resource "aws_subnet" "eks_subnet_cluster_mern" {
  vpc_id            = aws_vpc.eks_vpc_cluster_mern.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

}


resource "aws_subnet" "eks_subnet_cluster_mern2" {
  vpc_id            = aws_vpc.eks_vpc_cluster_mern.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
}

///////
resource "aws_iam_policy" "ec2_describe_network_interfaces_policy" {
  name        = "ec2-describe-network-interfaces-policy"
  description = "Allows describing EC2 network interfaces"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "ec2:DescribeNetworkInterfaces",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_describe_network_interfaces_attachment" {
  policy_arn = aws_iam_policy.ec2_describe_network_interfaces_policy.arn
  role       = aws_iam_role.eks_cluster_mern.name
}




///////

resource "aws_security_group" "eks_security_group_cluster_mern" {
  name_prefix = "eks_sg_"
  vpc_id      = aws_vpc.eks_vpc_cluster_mern.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "eks_cluster_mern" {
  name = "eks_cluster_mern"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_mern_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_mern.name

  depends_on = [
    aws_iam_role.eks_cluster_mern,
  ]
}

resource "aws_eks_cluster" "cluster_mern" {
  name     = "cluster-mern"
  role_arn = aws_iam_role.eks_cluster_mern.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_security_group_cluster_mern.id]
    subnet_ids         = [aws_subnet.eks_subnet_cluster_mern.id, aws_subnet.eks_subnet_cluster_mern2.id]
  }

  tags = {
    Name = "eks_vpc_cluster_mern"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_mern_attach
  ]
}

resource "aws_iam_role" "my_node_role" {
  name = "my_node_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

////
resource "aws_iam_policy_attachment" "eks_worker_node_policy_attachment" {
  name       = "my-eks-worker-node-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [aws_iam_role.my_node_role.name]
}

resource "aws_iam_policy_attachment" "ecr_read_only_policy_attachment" {
  name       = "my-ecr-read-only-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.my_node_role.name]
}


resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.cluster_mern.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.my_node_role.arn
  subnet_ids      = [aws_subnet.eks_subnet_cluster_mern.id]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

#launch template...
}
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.eks_subnet_cluster_mern.id
}



////kellll
# resource "aws_eks_node_group" "this" {
#   cluster_name    = aws_eks_cluster.this.name
#   node_group_name = "eks-node-group"
#   node_role_arn   = aws_iam_role.eks_node.arn
#   subnet_ids      = aws_subnet.private.*.id

#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }

#   launch_template {
#     id      = aws_launch_template.this.id
#     version = aws_launch_template.this.latest_version
#   }
# }

# resource "aws_launch_template" "this" {
#   name_prefix   = "eks-node-group"
#   image_id      = data.aws_ami.eks_worker.id
#   instance_type = "t2.small"
#   key_name      = "your-key-pair-name"

#   user_data = base64encode(templatefile("${path.module}/userdata.tpl", {
#     cluster_name = local.cluster_name
#     endpoint     = aws_eks_cluster.this.endpoint
#     cluster_ca   = aws_eks_cluster.this.certificate_authority[0].data
#   }))

#   iam_instance_profile {
#     name = aws_iam_instance_profile.eks_node.name
#   }
# }
////

//
# resource "aws_launch_template" "example" {
#   name_prefix   = "example-template"
#   image_id      = "ami-12345678"
#   instance_type = "t2.micro"

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 30
#     }
#   }

#   network_interfaces {
#     device_index              = 0
#     subnet_id                 = aws_subnet.example.id
#     security_groups           = [aws_security_group.example.id]
#     associate_public_ip_address = true
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "example-instance"
#     }
#   }
# }

# resource "aws_subnet" "example" {
#   vpc_id                  = aws_vpc.example.id
#   cidr_block              = "10.0.0.0/24"
#   availability_zone       = "us-west-2a"
# }

# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_security_group" "example" {
#   name        = "example-security-group"
#   description = "Example security group"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }





//





///associate_public_ip_address = true



# resource "aws_eks_node_group" "my_node_group_dd" {
#   cluster_name    = aws_eks_cluster.prometheus_grafana_cluster_dd.name
#   node_group_name = "my-node-group-dd"
#   node_role_arn   = aws_iam_role.my_node_role.arn
#   subnet_ids      = [aws_subnet.eks_subnet_cluster_dd_1.id, aws_subnet.eks_subnet_cluster_dd_2.id]
#   scaling_config {
#     desired_size = 2
#     max_size     = 2
#     min_size     = 2
#   }
#   tags = {
#     Terraform   = "true"
#     Environment = "true"
#   }
# }



# resource "aws_instance" "ec2-tf" {
#   ami           = "ami-0ec7f9846da6b0f61"
#   instance_type = "t3.micro"
#   subnet_id                   = aws_subnet.basicsubnet-dd.id
#   vpc_security_group_ids= [aws_security_group.basicsecgroup-dd.id]

#   key_name                    = "domotor_david_1.2"
#   associate_public_ip_address = true
#     # intanece-on belul igy lehet alkalmazast inditani
#     # user_data = <<-EOF
#     #           #!/bin/bash
#     #           sudo apt-get update
#     #           sudo apt-get install -y nginx 
#     #           sudo apt-get install npm -y
            
#     #           sudo apt install nodejs
#     #           sudo npm install pm2@latest -g



            
#     #           EOF





#   tags = {
#     Name = "basic subnet tag"
#   }
  
  
# }

# output "public_ip" {
#   value = aws_instance.ec2-tf.public_ip
# }