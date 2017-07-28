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

resource "aws_instance" "mail" {
  ami = "ami-269bc55d"
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

  provisioner "file" {
    source = "ansible"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-playbook /home/ubuntu/ansible/bootstrap/mail.yml"
    ]
  }
}

output "mail ip" {
  value = "${aws_instance.mail.public_ip}"
}