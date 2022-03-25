import os
import string

import pyximport
pyximport.install()
from lexer import Lexer
from executer import execute
from termcolor import colored
from commands import create_commands
import getpass

create_commands()
curr_dir = f'C:\\Users\\{getpass.getuser()}'
os.chdir(curr_dir)
def run(text):
    lexer = Lexer(text)
    tokens = lexer.make_tokens()
    execute(tokens)

while True:
    text = input(colored(f'>{colored(os.getcwd() + ":", "green")} ', 'blue'))
    run(text)