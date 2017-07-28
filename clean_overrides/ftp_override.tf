resource "aws_route53_record" "ftp" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "ftp.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.ftp.private_ip}"]
  depends_on = ["aws_instance.ftp", "aws_route53_zone.terraform"]
}

resource "aws_instance" "ftp" {
  ami = "(build-ami)"
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

  provisioner "file" {
    source = "ansible"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-playbook /home/ubuntu/ansible/bootstrap/ftp.yml"
    ]
  }
}

output "ftp ip" {
  value = "${aws_instance.ftp.public_ip}"
}