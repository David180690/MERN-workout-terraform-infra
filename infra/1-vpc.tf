resource "aws_vpc" "main_mern" {
  cidr_block = "10.0.0.0/16"
  # enable_dns_support =true
  # enable_dns_hostnames = true

  tags = {
    Name = "main_mern"
  }

}

# output "vpc_id" {
#   value=aws_vpc.main_mern.id
#   description ="VPC id."
#   sensitive = false
# }