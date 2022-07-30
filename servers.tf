resource "aws_instance" "bastion_host" {
  ami             = "ami-0cff7528ff583bf9a"
  instance_type   = "t2.micro"
  key_name        = "bastion_key"
  security_groups = ["${aws_security_group.ingress-ssh.id}"]
  subnet_id       = element(module.vpc.public_subnets, 0)
  tags = {
    Name = "bastion_host"
  }
}

