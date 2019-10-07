resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "default" {
    route_table_id = "${aws_vpc.default.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
}

resource "aws_security_group" "ams" {
  name = "ams"
  description = "Base security group for AMS instances"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    description = "allow egress to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow SSH in from anywhere
  ingress {
    description = "allow SSH in from anywhere"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow HTTP in from anywhere"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow HTTPS in from anywhere"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow AMS Admin RTMP in from anywhere"
    protocol    = "tcp"
    from_port   = 1111
    to_port     = 1111
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow RTMP streams in from anywhere"
    protocol    = "tcp"
    from_port   = 1935
    to_port     = 1935
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ICMP within VPC
  ingress {
    protocol  = "icmp"
    from_port = -1
    to_port   = -1
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  egress {
    protocol  = "icmp"
    from_port = -1
    to_port   = -1
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }
}

resource "aws_subnet" "ams_a" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_vpc" "default" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}
