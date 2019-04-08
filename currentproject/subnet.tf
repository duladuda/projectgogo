#Create subnet one
resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.cidr_subnet1}"

  tags = {
  Name = "PublicSubnetDula"
  }
}

#Create subnet two
# resource "aws_subnet" "mainprivate" {
#   vpc_id     = "${aws_vpc.main.id}"
#   cidr_block = "${var.cidr_subnet2}"

#   tags = {
#   Name = "PrivateSubnetDula"
#   }
# }
