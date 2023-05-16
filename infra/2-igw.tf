resource "aws_internet_gateway" "my_igw_mern" {
  vpc_id = aws_vpc.eks_vpc_cluster_mern.id

  tags = {
    Name = "igw_mern"
  }

}