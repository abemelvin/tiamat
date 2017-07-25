resource "aws_instance" "elk" {
  count = "${var.logging}"
  ami = "(elk-ami)"
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

output "elk ip" {
  value = "${aws_instance.elk.public_ip}"
}