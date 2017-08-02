#!/usr/bin/expect -f

spawn ssh john@payments.fazio.com

expect {
  "key fingerprint" {send "yes\r"; exp_continue}
  "password:" {send "blackhat\r"}
}

expect "$ "
send "ftp ftp.fazio.com\r"

expect "Name"
send "anonymous\r"

expect "Password"
send "blackhat@fazio.com\r"

expect "ftp>"
send "lcd /home/john\r"

expect "ftp>"
send "cd /upload\r"

expect "ftp>"
send "put transactions.txt\r"

expect "ftp>"
send "bye\r"

expect "$ "
send "exit\r"