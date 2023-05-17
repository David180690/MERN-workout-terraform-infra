# data "aws_vpc" "main_mern" {
#   id="vpc-037...."
# }


resource "aws_internet_gateway" "igw_mern" {
  vpc_id = aws_vpc.main_mern.id
  # vpc_id= data.aws_vpc.main_mer.id

  tags = {
    Name = "igw_mern"
  }

}