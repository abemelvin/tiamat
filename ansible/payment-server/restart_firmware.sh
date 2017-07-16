#!/usr/bin/expect -f

spawn scp /home/ubuntu/payment-server/pos_firmware.py update@sales.fazio.com:/home/update/pos_firmware.py

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "maintenance\r"}
}

expect "100%"
wait 1
send "exit\r"

wait 1

spawn ssh update@sales.fazio.com

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "maintenance\r"}
}

expect "$ "
send "sudo ufw allow 6666\r"

expect "$ "
send "sudo mv /home/update/pos_firmware.py /home/ubuntu/payment-server/pos_firmware.py\r"

expect "$ "
send "sudo chmod 777 /home/ubuntu/payment-server/pos_firmware.py\r"

expect "$ "
send "sudo python /home/ubuntu/payment-server/pos_firmware.py >/dev/null 2>&1 &\r"

expect "$ "
send "exit\r"