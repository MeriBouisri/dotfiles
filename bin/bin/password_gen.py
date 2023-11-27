#!/usr/bin/python3

import argparse
import secrets
import string
import sys

parser = argparse.ArgumentParser()

parser.add_argument('--len', action='store', dest='pwd_length', default=5)
parser.add_argument('-l', '--lowercase', action='store_true', dest='contains_lowercase', default=True)
parser.add_argument('-d', '--digits', action='store_true', dest='contains_digits', default=False)
parser.add_argument('-u', '--uppercase', action='store_true', dest='contains_uppercase', default=False)
parser.add_argument('-s', '--special', action='store_true', dest='contains_special', default=False)
args = parser.parse_args()

ascii_lowercase = string.ascii_lowercase
ascii_uppercase = string.ascii_uppercase
digits = string.digits
special_chars = string.punctuation

pwd_categories = 4
password = ""

while len(password) < int(args.pwd_length):
    rand_num = secrets.randbelow(pwd_categories)

    match rand_num:
        case 0:
            if args.contains_lowercase:
                password += secrets.choice(ascii_lowercase)

        case 1:
            if args.contains_uppercase:
                password += secrets.choice(ascii_uppercase)

        case 2:
            if args.contains_digits:
                password += secrets.choice(digits)

        case 3:
            if args.contains_special:
                password += secrets.choice(special_chars)

print(password)

    





