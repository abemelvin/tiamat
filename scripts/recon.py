import ftplib

def main():
  host = "ftp.fazio.com"
  port = 21
  username = "anonymous"
  password = "contractor@fazio.com"
  ftp = ftplib.FTP(host, username, password)
  ftp.connect(host, port)
  ftp.login()
  ftp.cwd("upload")
  ftp.storbinary("STOR recon.zip", open("recon.zip", "rb"))
  ftp.close()

if __name__== "__main__":
  main()