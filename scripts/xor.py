import sys
import getopt
from itertools import cycle, izip

KEY = 's3cr3t'

# method from: https://dustri.org/b/elegant-xor-encryption-in-python.html
def encrypt(message):
    return(''.join(chr(ord(c)^ord(k)) for c,k in izip(message, cycle(KEY))))

def main(argv):
    if len(argv) == 0:
        print("Error! No argument(s) specified.")
        return
    inputfile = argv[0]
    if len(argv) == 1:
        outputfile = inputfile
    else:
        outputfile = argv[1]

    f1 = open(inputfile, "r")
    f2 = open(outputfile, "a+")
    f2.write(encrypt(f1.read()))
    f1.close()
    f2.close()

if __name__ == "__main__":
    main(sys.argv[1:])