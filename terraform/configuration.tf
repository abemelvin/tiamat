provider "aws" {}

resource "aws_subnet" "control" {
  vpc_id = "vpc-17d6d271"
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "terraform" {
  name = "terraform"
  description = "Allow all traffic"
  vpc_id = "vpc-17d6d271"

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
  ami           = "ami-f4cc1de2"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.control.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.10"
  depends_on = ["aws_security_group.terraform", "aws_subnet.control", "aws_instance.elk", "aws_instance.demo"]

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
      "ansible-playbook install/elk.yml",
      "ansible-playbook install/filebeat.yml",
      "ansible-playbook install/packetbeat.yml",
      "ansible-playbook install/metricbeat.yml",
      "ansible-playbook scripts/index.yml",
      "ansible-playbook scripts/dns_setup.yml"
    ]
  }
}

resource "aws_instance" "elk" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.xlarge"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.control.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.11"
  depends_on = ["aws_security_group.terraform", "aws_subnet.control"]

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

resource "aws_instance" "demo" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.control.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.12"
  depends_on = ["aws_security_group.terraform", "aws_subnet.control"]

  connection {
    host = "${aws_instance.demo.public_ip}"
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

resource "aws_instance" "dns" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "terraform"
  subnet_id = "${aws_subnet.control.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.13"
  depends_on = ["aws_security_group.terraform", "aws_subnet.control"]

  connection {
    host = "${aws_instance.dns.public_ip}"
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
  subnet_id = "${aws_subnet.control.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.14"
  depends_on = ["aws_security_group.terraform", "aws_subnet.control"]

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
