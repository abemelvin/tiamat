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

output "wazuh ip" {
  value = "${aws_instance.wazuh.public_ip}"
}