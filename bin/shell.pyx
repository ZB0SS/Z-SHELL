import string

import pyximport
pyximport.install()
from lexer import Lexer

def run(text):
    lexer = Lexer(text)
    tokens = lexer.make_tokens()

while True:
    text = input('> ')
    run(text)