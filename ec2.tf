# https://cloud-images.ubuntu.com/locator/ec2/
# ubuntu 18.04 lts hvm:instance-store ami-04aa802b835dec952
# ubuntu 18.04 lts hvm:ebs-ssd ami-06d51e91cea0dac8d 

resource "aws_instance" "ams_5015" {
  ami                         = "ami-06d51e91cea0dac8d"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.default.key_name
  subnet_id                   = aws_subnet.ams_a.id
  user_data                   = file("cloud-init.sh")
  vpc_security_group_ids      = [aws_security_group.ams.id]
}

resource "aws_eip" "ams_5015" {
  instance = aws_instance.ams_5015.id
}

output "ams_5015_public_dns" {
  value = aws_eip.ams_5015.public_dns
}

output "ams_5015_public_ip" {
  value = aws_eip.ams_5015.public_ip
}

resource "aws_instance" "ams_demo" {
  ami                         = "ami-06d51e91cea0dac8d"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.default.key_name
  subnet_id                   = aws_subnet.ams_a.id
  user_data                   = file("cloud-init.sh")
  vpc_security_group_ids      = [aws_security_group.ams.id]
}

resource "aws_eip" "ams_demo" {
  instance = aws_instance.ams_demo.id
}

output "ams_demo_public_dns" {
  value = aws_eip.ams_demo.public_dns
}

output "ams_demo_public_ip" {
  value = aws_eip.ams_demo.public_ip
}

resource "aws_instance" "livefeed_demo" {
  ami                         = "ami-06d51e91cea0dac8d"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.default.key_name
  subnet_id                   = aws_subnet.ams_a.id
  user_data                   = file("livefeed-cloud-init.sh")
  vpc_security_group_ids      = [aws_security_group.ams.id]
}

resource "aws_eip" "livefeed_demo" {
  instance = aws_instance.livefeed_demo.id
}

output "livefeed_demo_public_dns" {
  value = aws_eip.livefeed_demo.public_dns
}

output "livefeed_demo_public_ip" {
  value = aws_eip.livefeed_demo.public_ip
}

resource "aws_key_pair" "default" {
  key_name   = "default ssh key"
  public_key = var.ssh_public_key
}
