from pathlib import Path
from cryptography.fernet import Fernet
import sys, os

def cls():
    if os.name == "nt": os.system("cls")
    else: os.system("clear")

def genkey():
    key = Fernet.generate_key()
    with open("key.key", "wb") as f: f.write(key)
    print("Created new key in key.key")

def encFile(path, fernet):
    with open(path, "rb") as f: data = f.read()
    encrypted = fernet.encrypt(data)
    with open(path, "wb") as f: f.write(encrypted)

def decFile(path, fernet):
    with open(path, "rb") as f: encData = f.read()
    try: dec = fernet.decrypt(encData)
    except Exception:
        print("Error: file is not encrypted, so can't decrypt")
        return False

    with open(path, "wb") as f: f.write(dec)
    return True

def action(type):
    try:
        with open("key.key", "rb") as f: key = f.read()

    except Exception:
        cls()
        print("Error: key file not found! (Use 'genkey' arg to generate a new key file)")
        return

    fernet = Fernet(key)

    try: folder = sys.argv[2]
    except Exception:
        cls()
        print("Error: folder argument missing")
        return

    for file in Path(folder).rglob("*"):
        if (file.is_file()):
            match type:
                case "enc": encFile(file, fernet)
                case "dec":
                    if (not decFile(file, fernet)): return

    print(f"Applied '{type}' on folder '{folder}'")
    return

while True:
    cls()
    try: sys.argv[1]
    except Exception:
        print("Use a argument: ['enc %folder-name%', 'dec %folder-name%', 'genkey']")
        break

    mainArg = sys.argv[1]

    if (mainArg == "genkey"):
        genkey()
        break

    elif (mainArg == "enc" or mainArg == "dec"):
        action(mainArg)
        break
