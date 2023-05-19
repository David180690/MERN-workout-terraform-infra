resource "aws_iam_role" "nodes-dd" {
  name = "eks-node-group-nodes-dd"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-dd-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes-dd.name
}
# 
resource "aws_iam_role_policy_attachment" "nodes-dd-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes-dd.name
}

resource "aws_iam_role_policy_attachment" "nodes-dd-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes-dd.name
}

resource "aws_eks_node_group" "private-nodes-dd" {

  cluster_name    = aws_eks_cluster.demo_mern.name
  node_group_name = "private-nodes-dd"
  node_role_arn   = aws_iam_role.nodes-dd.arn

  subnet_ids = [
    aws_subnet.private-eu-central-1a.id,
    aws_subnet.private-eu-central-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-dd-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-dd-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-dd-AmazonEC2ContainerRegistryReadOnly,
  ]
}
