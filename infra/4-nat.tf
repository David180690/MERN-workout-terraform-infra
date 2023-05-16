resource "aws_eip" "mern" {
  vpc = true

  tags = {
    Name = "mern"
  }
}

resource "aws_nat_gateway" "mern" {
  allocation_id = aws_eip.mern.id
  subnet_id     = aws_subnet.public-eu-central-1a.id

  tags = {
    Name = "mern"
  }

  depends_on = [aws_internet_gateway.igw_mern]
}
