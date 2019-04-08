#Create EC2 instance with apache2 instaled

# data "aws_ami" "ubuntu" {
#  most_recent = true


#   filter {
#    name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }

# filter {
# name   = "virtualization-type"
# values = ["hvm"]
#  }

# owners = ["099720109477"] # Canonical
# }


resource "aws_instance" "dulajenkinsserver" {
ami           = "ami-08935252a36e25f85"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.main.id}"
key_name =  "${aws_key_pair.my-key.key_name}"  

associate_public_ip_address = true
 vpc_security_group_ids = ["${aws_security_group.allow_outgoing.id}"]

# #  user_data = <<-EOF
# #              #!/bin/bash
# #                #sudo yum update -y   
# #                #sudo yum install java-1.8.0-openjdk-devel -y
# #                #sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# #                #sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
# #                #sudo yum install jenkins -y
# #                #sudo service jenkins start
# #              #apt-get update
# #              #apt-get upgrade -y
# #              #apt-get install apache2 -y
# #              E
 tags = {
  Name = "DulaJenkinsServer"}

  }

  resource "aws_instance" "dulajenkinsslave" {
ami           = "ami-08935252a36e25f85"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.main.id}"
key_name =  "${aws_key_pair.my-key.key_name}" 

associate_public_ip_address = true
 vpc_security_group_ids = ["${aws_security_group.allow_outgoing.id}"]

#  user_data = <<-EOF
#              #!/bin/bash
#              #apt-get update
#              #apt-get upgrade -y
#              #apt-get install apache2 -y
#              EOF

 tags = {
  Name = "DulaJenkinsSlave"}

  }

  resource "aws_security_group" "allow_outgoing" {
 name = "allow_outgoing"
 vpc_id      = "${aws_vpc.main.id}"

 # Allow VM external access
 #ingress {
    # TLS (change to whatever ports you need)
    # from_port   = 80
    # to_port     = 80
    # protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]

# }
 
 ingress {
    # TLS (change to whatever ports you need)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

   egress {
   from_port       = 0
   to_port         = 0
   protocol        = "-1"
   cidr_blocks     = ["0.0.0.0/0"]
 }
  }

resource "aws_key_pair" "my-key" {
 key_name   = "my-key"
 public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_eip" "dulaeip" {
  vpc = true

  instance                  = "${aws_instance.dulajenkinsserver.id}"
  associate_with_private_ip = "${aws_instance.dulajenkinsserver.private_ip}"
  depends_on                = ["aws_internet_gateway.gw"]
}
output "outputpublicdns" {
  value = "${aws_eip.dulaeip.public_ip}"
  }


