resource "aws_instance" "wazuh" {
  count = "${var.logging}"
  ami = "ami-d19bc5aa"
  instance_type = "t2.large"
  security_groups = ["${aws_security_group.terraform.id}"]
  key_name = "key"
  subnet_id = "${aws_subnet.terraform.id}"
  associate_public_ip_address = true
  private_ip = "10.0.0.12"
  depends_on = ["aws_route_table.terraform", "aws_security_group.terraform", "aws_subnet.terraform", "aws_instance.elk"]

  connection {
    host = "${aws_instance.wazuh.public_ip}"
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
      "ansible-playbook /home/ubuntu/ansible/bootstrap/wazuh.yml"
    ]
  }
}

output "wazuh ip" {
  value = "${aws_instance.wazuh.public_ip}"
}