resource "aws_instance" "bastion_host" {
  ami             = "ami-05fa00d4c63e32376"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.ingress-ssh.id}"]
  subnet_id       = element(module.vpc.public_subnets, 0)
  tags = {
    Name = "bastion_host"
  }
}

