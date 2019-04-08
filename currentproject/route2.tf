# #Create Route 2 for private subnet
# resource "aws_route_table" "ra" {
#   vpc_id = "${aws_vpc.main.id}"
#   }



# resource "aws_route_table_association" "rta" {
#   subnet_id      = "${aws_subnet.mainprivate.id}"
#   route_table_id = "${aws_route_table.ra.id}"
# } 