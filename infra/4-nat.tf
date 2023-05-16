resource "aws_eip" "eip_mern" {
  vpc = true

  tags = {
    Name = "eip_mern"
  }
}

resource "aws_nat_gateway" "nat_mern" {
  allocation_id = aws_eip.eip_mern.id
  subnet_id     = aws_subnet.public-eu-central-1a.id

  tags = {
    Name = "nat_mern"
  }

  depends_on = [aws_internet_gateway.igw_mern]
}
