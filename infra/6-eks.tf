resource "aws_iam_role" "demo_mern" {
  name = "eks-cluster-demo_mern"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy_mern" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo_mern.name
}

variable "cluster_name" {
  default = "demo_mern"
  type = string
  description = "AWS EKS Cluster Name"
 # nullable = false
}

resource "aws_eks_cluster" "demo_mern" {
  name     = var.cluster_name
  role_arn = aws_iam_role.demo_mern.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-eu-central-1a.id,
      aws_subnet.private-eu-central-1b.id,
      aws_subnet.public-eu-central-1a.id,
      aws_subnet.public-eu-central-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy_mern]
}
