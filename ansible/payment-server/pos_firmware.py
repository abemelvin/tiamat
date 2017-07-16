#!/usr/bin/python

import MySQLdb
import string
import random
import time
import sys
import thread
import traceback
import subprocess
import hashlib


class NormalPOS:

    def __init__(self):
        # Open database connection
        host = "10.0.0.20"  # private ip address of payment server: 10.0.0.20
        user = "root"
        passwd = "root"
        db_name = "payment_db"
        self.db = MySQLdb.connect(host, user, passwd, db_name)

        # prepare a cursor object using cursor() method
        self.cursor = self.db.cursor()
        self.port = "5555"

    @staticmethod
    def redact_info(credit_card_no):
        return '*' * 12 + credit_card_no[12:]

    def run(self):
        print "normal POS firmware running..."

        with open("/home/ubuntu/payment-server/pos_firmware.py", "r") as firmware:
            m = hashlib.md5(firmware.read())
            old_checksum = m.digest()

        # keep opening nc listening port to receive firmware update
        #with open("/home/ubuntu/payment-server/pos_firmware.py", "w+") as firmware:
        #    if subprocess.Popen(["nc", "-l", "-p", str(self.port)], stdout=firmware, stderr=subprocess.PIPE) == 0:
        #        print "received firmware update, exiting..."
        #        exit(0)

        while True:

            with open("/home/ubuntu/payment-server/pos_firmware.py", "r") as firmware:
                m = hashlib.md5(firmware.read())
                new_checksum = m.digest()

            if new_checksum != old_checksum:
                print "detected firmware update, restarting..."
                exit(0)

            transac_id = ''.join(random.choice(string.digits) for _ in range(8))
            datetime = time.strftime('%Y-%m-%d %H:%M:%S')
            content = ''.join(random.choice(string.ascii_letters) for _ in range(8))
            amount = random.uniform(1, 10000)
            credit_card_no = ''.join(random.choice(string.digits) for _ in range(16))
            rd_credit_card_no = NormalPOS.redact_info(credit_card_no)

            sql = "INSERT INTO transactions(transac_id, \
                     datetime, content, amount, credit_card_no) \
                     VALUES ('%s', '%s', '%s', '%.2f', '%s')" % \
                  (transac_id, datetime, content, amount, rd_credit_card_no)
            try:
                # Execute the SQL command
                self.cursor.execute(sql)

                # Commit your changes in the database
                self.db.commit()

                print "one record inserted."
            except Exception as e:
                traceback.print_exc(e)
                # Rollback in case there is any error
                self.db.rollback()

            # assume interval is drawn from exp distribution
            interval = random.expovariate(0.1)
            # insert one record every interval seconds
            time.sleep(interval)


if __name__ == '__main__':
    client = NormalPOS()
    try:
        client.run()
    finally:
        # disconnect from server
        print "client shutdown."
        client.db.close()

    sys.exit()

