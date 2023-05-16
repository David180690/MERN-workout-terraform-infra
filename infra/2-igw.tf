resource "aws_internet_gateway" "igw_mern" {
  vpc_id = aws_vpc.main_mern.id

  tags = {
    Name = "igw_mern"
  }

}