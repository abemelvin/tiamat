def main():
  f = open("logs.txt","a+")
  f.write("username: contractor@fazio.com \r\n")
  f.write("password: password \r\n")
  f.close()

if __name__== "__main__":
  main()