<sub>[Back](./README.md)</sub>

# Password Generator

Python based offline password generator with options similar to what passwordgenerator.net used to offer. Copies generated password to clipboard and displays in stdout. 

```py
import random
from string import ascii_lowercase, ascii_uppercase, digits, punctuation

# params 
length = 16
includeSymbols = True
includNumbers = True
includeLowercase = True
includeUppercase = True
excludeSameCharacters = True
excludeAmbiguousChar = True
AmbiguousChar = """{}[]()/\'"`~,;:.<>"""
sameChar = ['i','I','l','1','o','O','0']
autoCopy = True

stringsDB = ''
if includeSymbols:
    stringsDB += punctuation
if includNumbers:
    stringsDB += digits
if includeLowercase:
    stringsDB += ascii_lowercase
if includeUppercase:
    stringsDB += ascii_uppercase
if excludeSameCharacters:
    for char in sameChar:
        stringsDB = stringsDB.replace(char, '')
if excludeAmbiguousChar:
    for char in AmbiguousChar:
        stringsDB = stringsDB.replace(char, '')

def generate_password(length):
    password = ''.join(random.choice(stringsDB) for _ in range(length))
    return password

if __name__ == "__main__":
    password = generate_password(length)
    print("Generated Password:", password)
    if autoCopy:
        try:
            import pyperclip
            pyperclip.copy(password)
            print("Password copied to clipboard.")
        except ImportError:
            print("pyperclip module not found. Install it to enable clipboard copy functionality.")
```