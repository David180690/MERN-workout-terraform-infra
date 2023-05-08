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



resource "aws_subnet" "eks_subnet_cluster_mern" {
  vpc_id            = aws_vpc.eks_vpc_cluster_mern.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "eks_subnet_cluster_mern2" {
  vpc_id            = aws_vpc.eks_vpc_cluster_mern.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
}

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
  subnet_ids      = [aws_subnet.eks_subnet_cluster_mern.id, aws_subnet.eks_subnet_cluster_mern2.id]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.eks_subnet_cluster_mern.id
}



resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.eks_subnet_cluster_mern2.id
}





///



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