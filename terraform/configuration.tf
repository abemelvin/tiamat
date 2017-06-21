provider "aws" {}

resource "aws_key_pair" "terraform" {
  key_name = "key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/Owd1mxio0N+z8T3EUXZzkYtxIYm6iWSpPk7B67yD5JlnaAAlVSeXzWiYUtkawYUx1JKMQapkhTlBzZYB079qKbYG0Dk7x3yFwtnWUR4iSYcw5o8QknLy2F+Rc8qV/lhVHnD8sy9jKJoozLy1Jzrm0YabsKvJQB4TFAID63knlGUuhzeVKaKKk6YQb93+UKOXqmUrVa0x6DIbKmZ+WrH9y+ubUrhG9T//uub1OTILOSbElyMsh5AL/gSZkktuVIlq2eI6Cvva9r9UqycXnjtSzioZty1VdFk54Ag0Ijpgw0kK1dNuWOQaM/lzKySjodLJAHG4uwvVHvmgAPJDSC/5 abemelvin@MacBook-Pro.local"
}

resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "terraform" {
  vpc_id = "${aws_vpc.terraform.id}"
  depends_on = ["aws_vpc.terraform"]
}

resource "aws_route_table" "terraform" {
  vpc_id = "${aws_vpc.terraform.id}"
  depends_on = ["aws_internet_gateway.terraform"]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform.id}"
  }
}

resource "aws_subnet" "terraform" {
  vpc_id = "${aws_vpc.terraform.id}"
  cidr_block = "10.0.0.0/24"
  depends_on = ["aws_vpc.terraform"]
}

resource "aws_route_table_association" "terraform" {
  subnet_id = "${aws_subnet.terraform.id}"
  route_table_id = "${aws_route_table.terraform.id}"
  depends_on = ["aws_subnet.terraform", "aws_route_table.terraform"]
}

resource "aws_route53_zone" "terraform" {
  name = "fazio.com"
  vpc_id = "${aws_vpc.terraform.id}"
  depends_on = ["aws_vpc.terraform"]
}

resource "aws_route53_record" "wazuh" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "wazuh.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.wazuh.private_ip}"]
  depends_on = ["aws_instance.wazuh", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "contractor" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "contractor.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.contractor.private_ip}"]
  depends_on = ["aws_instance.contractor", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "blackhat" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "blackhat.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.blackhat.private_ip}"]
  depends_on = ["aws_instance.blackhat", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "ftp" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "ftp.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.ftp.private_ip}"]
  depends_on = ["aws_instance.ftp", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "ldap" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "ldap.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.ldap.private_ip}"]
  depends_on = ["aws_instance.ldap", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "mail_A" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "mail.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.mail.private_ip}"]
  depends_on = ["aws_instance.mail", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "mail_MX" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "fazio.com"
  type = "MX"
  ttl = "300"
  records = ["50 mail.fazio.com"]
  depends_on = ["aws_instance.mail", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "webapp" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "webapp.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.webapp.private_ip}"]
  depends_on = ["aws_instance.webapp", "aws_route53_zone.terraform"]
}

resource "aws_security_group" "terraform" {
  name = "terraform"
  description = "allow all traffic"
  vpc_id = "${aws_vpc.terraform.id}"
  depends_on = ["aws_vpc.terraform"]

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.10"
  depends_on = ["aws_security_group.terraform", "aws_subnet.terraform", "aws_instance.elk", "aws_instance.wazuh", "aws_instance.contractor", "aws_instance.mail", "aws_instance.webapp", "aws_instance.ldap", "aws_instance.blackhat", "aws_instance.ftp"]

  connection {
    host = "${aws_instance.ansible.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
    }

  provisioner "file" {
    source = "ansible/"
    destination = "~"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install ansible -y",
      "sudo mv hosts /etc/ansible/hosts",
      "sudo mv ansible.cfg /etc/ansible/ansible.cfg",
      "sudo chmod 600 key",
      #"ansible-playbook install/elk.yml",
      #"ansible-playbook install/filebeat.yml",
      #"ansible-playbook install/packetbeat.yml",
      #"ansible-playbook install/metricbeat.yml",
      #"ansible-playbook scripts/index.yml",
      #"ansible-playbook install/webapp.yml",
      #"ansible-playbook install/mail.yml",
      #"ansible-playbook install/contractor.yml",
      #"ansible-playbook install/blackhat.yml",
      #"ansible-playbook install/ftp.yml",
      #"ansible-playbook install/ldap.yml",
      "ansible-playbook install/wazuh.yml",
      "echo provisioning complete"
    ]
  }
}

resource "aws_instance" "elk" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.large"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.11"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.elk.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
    }
}

resource "aws_instance" "wazuh" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.large"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.12"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.wazuh.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
    }
}

resource "aws_instance" "contractor" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.14"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.contractor.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }
}

resource "aws_instance" "mail" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.small"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.15"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.mail.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }
}

resource "aws_instance" "webapp" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.small"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.16"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.webapp.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }

  provisioner "file" {
    source = "ansible/web-server/html"
    destination = "~"
  }
}

resource "aws_instance" "ldap" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.small"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.17"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.ldap.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }
}

resource "aws_instance" "blackhat" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.18"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.blackhat.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }

  provisioner "file" {
    source = "scripts/"
    destination = "~"
  }
}

resource "aws_instance" "ftp" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.19"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.ftp.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }
}

output "ansible ip" {
  value = "${aws_instance.ansible.public_ip}"
}

output "elk ip" {
  value = "${aws_instance.elk.public_ip}"
}

output "wazuh ip" {
  value = "${aws_instance.wazuh.public_ip}"
}

output "contractor ip" {
  value = "${aws_instance.contractor.public_ip}"
}

output "mail ip" {
  value = "${aws_instance.mail.public_ip}"
}

output "webapp ip" {
  value = "${aws_instance.webapp.public_ip}"
}

output "ldap ip" {
  value = "${aws_instance.ldap.public_ip}"
}

output "blackhat ip" {
  value = "${aws_instance.blackhat.public_ip}"
}

output "ftp ip" {
  value = "${aws_instance.ftp.public_ip}"
}