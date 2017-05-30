provider "aws" {}

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

resource "aws_route53_record" "contractor" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "contractor.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.contractor.private_ip}"]
  depends_on = ["aws_instance.contractor", "aws_route53_zone.terraform"]
}

resource "aws_route53_record" "mail" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "mail.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.mail.private_ip}"]
  depends_on = ["aws_instance.mail", "aws_route53_zone.terraform"]
}

resource "aws_security_group" "terraform" {
  name = "terraform"
  description = "allow all traffic"
  vpc_id = "${aws_vpc.terraform.id}"
  depends_on = ["aws_vpc.terraform"]

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
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
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.10"
  depends_on = ["aws_security_group.terraform", "aws_subnet.terraform", "aws_instance.elk", "aws_instance.contractor", "aws_instance.mail", "aws_instance.webapp"]

  connection {
    host = "${aws_instance.ansible.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("terraform.pem")}"
    agent = false
    }

  provisioner "file" {
    source = "file_provision/"
    destination = "~"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install ansible -y",
      "sudo mv hosts /etc/ansible/hosts",
      "sudo mv ansible.cfg /etc/ansible/ansible.cfg",
      "sudo chmod 600 terraform.pem",
      #"ansible-playbook install/elk.yml",
      #"ansible-playbook install/filebeat.yml",
      #"ansible-playbook install/packetbeat.yml",
      #"ansible-playbook install/metricbeat.yml",
      #"ansible-playbook scripts/index.yml",
      "ansible-playbook scripts/webapp_setup.yml"
    ]
  }
}

resource "aws_instance" "elk" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.xlarge"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.11"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.elk.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("terraform.pem")}"
    agent = false
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python -y"
    ]
  }
}

resource "aws_instance" "contractor" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.12"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.contractor.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("terraform.pem")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python -y"
    ]
  }
}

resource "aws_instance" "mail" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.14"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.mail.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("terraform.pem")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python -y"
    ]
  }
}

resource "aws_instance" "webapp" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.15"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.mail.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("terraform.pem")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python -y"
    ]
  }
}

output "ansible ip" {
  value = "${aws_instance.ansible.public_ip}"
}

output "elk ip" {
  value = "${aws_instance.elk.public_ip}"
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
