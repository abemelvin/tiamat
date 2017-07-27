resource "aws_route53_record" "sales" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "sales.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.sales.private_ip}"]
  depends_on = ["aws_instance.sales", "aws_route53_zone.terraform"]
}

resource "aws_instance" "sales" {
  ami = "ami-58025d23"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.21"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.sales.public_ip}"
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
      "ansible-playbook /home/ubuntu/ansible/bootstrap/sales.yml"
    ]
  }
}

output "sales ip" {
  value = "${aws_instance.sales.public_ip}"
}