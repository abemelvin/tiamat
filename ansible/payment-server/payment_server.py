#!/usr/bin/python

import MySQLdb
import string
import random
import time
import sys
import thread
import traceback
import hashlib
import subprocess


class PaymentServer:
    def __init__(self):
        self.pos_ip = "localhost"
        self.pos_port = "5555"
        self.port = "6666"  # nc listening port of payment server

    def check_firmware(self):
        print "firmware check is running..."
        old_checksum = ''
        while True:
            # print "new check"
            with open("pos_firmware.py", "r") as firmware:
                m = hashlib.md5(firmware.read())
                new_checksum = m.digest()

            if new_checksum != old_checksum:
                # push new firmware
                print "detect firmware update"
                nc_call = "nc " + self.pos_ip + " " + self.pos_port + " < " + "pos_firmware.py"
                while subprocess.call(nc_call, shell=True) != 0:
                    pass

                old_checksum = new_checksum

            time.sleep(1)

    @staticmethod
    def run(self):
        print "payment server running..."

        while True:
            pass


if __name__ == '__main__':
    server = PaymentServer()
    try:
        server.check_firmware()
    finally:
        # disconnect from server
        print "client shutdown."

    sys.exit()

