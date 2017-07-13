resource "aws_route53_record" "download" {
  zone_id = "${aws_route53_zone.terraform.zone_id}"
  name = "download.fazio.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.download.private_ip}"]
  depends_on = ["aws_instance.download", "aws_route53_zone.terraform"]
}

resource "aws_instance" "download" {
  ami = "ami-f4cc1de2"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.19"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform"]

  connection {
    host = "${aws_instance.download.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("key")}"
    agent = false
  }
}

output "download ip" {
  value = "${aws_instance.download.public_ip}"
}