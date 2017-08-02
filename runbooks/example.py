import pexpect
import time
import os

###############################
# open tiamat.py
###############################

child = pexpect.spawn('python tiamat.py')
child.expect('(tiamat)')

###############################
# add servers
###############################

child.sendline('add server blackhat')
child.expect('(tiamat)')

###############################
# deploy the network
###############################

child.sendline('deploy')
while True:
    try:
        child.expect('\n', timeout=15)
        print(child.before)
    except Exception as e:
        break

###############################
# connect to ansible
###############################

child.sendline('ansible')
child.expect('key fingerprint')
child.sendline('yes')
child.expect('ubuntu@')
print child.before

###############################
# ping the blackhat machine
###############################

child.sendline('ping blackhat.fazio.com -c 3')
child.expect('ubuntu@')
print child.before

###############################
# disconnect from ansible
###############################

child.sendline('logout')
child.expect('(tiamat)')
print child.before

###############################
# save logs
###############################

child.sendline('save logs')
child.expect('(tiamat)')

###############################
# destroy the network
###############################

child.sendline('destroy')
child.expect('you really want to destroy')
child.sendline('yes')
while True:
    try:
        child.expect('\n', timeout=15)
        print(child.before)
    except Exception as e:
        break

###############################
# quit tiamat.py
###############################

child.sendline('quit')