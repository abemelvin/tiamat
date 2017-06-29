#!/usr/bin/python

import MySQLdb
import string
import random
import time
import sys
import thread
import traceback


class PaymentServer:

    def __init__(self):
        # Open database connection
        host = "localhost"
        user = "root"
        passwd = "root"
        db_name = "payment_db"
        self.db = MySQLdb.connect(host, user, passwd, db_name)

        # prepare a cursor object using cursor() method
        self.cursor = self.db.cursor()
        self.is_infected = False

    def check_firmware(self):
        print "firmware check is running..."
        while True:
            with open("pos_firmware", "r") as firmware:
                if "malicious" in firmware.readline():
                    self.is_infected = True
                    print "(malicious firmware)"
                else:
                    print "(normal firmware)"
                    self.is_infected = False
            time.sleep(3)

    @staticmethod
    def redact_info(credit_card_no):
        return '*' * 12 + credit_card_no[12:]

    def run(self):
        print "server running..."

        # start another thread to periodically check pos_firmware
        thread.start_new_thread(self.check_firmware, ())

        while True:
            transac_id = ''.join(random.choice(string.digits) for _ in range(8))
            datetime = time.strftime('%Y-%m-%d %H:%M:%S')
            content = ''.join(random.choice(string.ascii_letters) for _ in range(8))
            amount = random.uniform(1, 10000)
            credit_card_no = ''.join(random.choice(string.digits) for _ in range(16))
            rd_credit_card_no = PaymentServer.redact_info(credit_card_no)

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
                # print(e)
                # Rollback in case there is any error
                self.db.rollback()

            # store unredacted data in some sort of log file if infected
            if self.is_infected:
                with open("log_file", "a") as log_file:
                    unredacted_info = ("(transac_id, datetime, content, amount, credit_card_no) = "
                                       "('%s','%s', '%s', '%.2f', '%s')\n" %
                                       (transac_id, datetime, content, amount, credit_card_no))
                    log_file.write(unredacted_info)
                    log_file.close()

            # assume interval is drawn from exp distribution
            interval = random.expovariate(0.1)
            # insert one record every interval seconds
            time.sleep(interval)


if __name__ == '__main__':
    server = PaymentServer()
    try:
        server.run()
    finally:
        # disconnect from server
        print "server shutdown."
        server.db.close()

    sys.exit()

