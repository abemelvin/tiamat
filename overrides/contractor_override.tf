resource "aws_route53_record" "contractor" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "contractor.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.contractor.private_ip}"]
  depends_on = ["aws_instance.contractor", "aws_route53_zone.terraform"]
}

resource "aws_instance" "contractor" {
  ami = "ami-e8722c93"
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

  provisioner "file" {
    source = "ansible"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-playbook /home/ubuntu/ansible/bootstrap/contractor.yml"
    ]
  }
}

output "contractor ip" {
  value = "${aws_instance.contractor.public_ip}"
}