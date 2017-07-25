import ftplib
import sys

def main(argv):
  if len(argv) == 0:
    print("Error! No argument(s) specified.")
    return
  inputfile = argv[0]

  host = "downloads.fazio.com"
  port = 21
  username = "anonymous"
  password = "contractor@fazio.com"
  ftp = ftplib.FTP(host, username, password)
  ftp.connect(host, port)
  ftp.login()
  ftp.cwd("download")
  ftp.storbinary("STOR " + inputfile, open(inputfile, "rb"))
  ftp.close()

if __name__ == "__main__":
  main(sys.argv[1:])