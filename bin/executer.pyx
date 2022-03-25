from termcolor import colored
import pyximport
pyximport.install()
from commands import COMMANDS, COMMAND_NAMES
from tokens import TOKEN_TYPES

def execute(tokens):
    if 'COMMAND' in TOKEN_TYPES:
        # print(colored('\t Command Passed!', 'green'))
        command = tokens[0].value
        args = []
        options = []
        for token in tokens:
            if token.type == 'ARG':
                args.append(token)
            elif token.type == 'OPTION':
                options.append(token.value)
        if command in COMMAND_NAMES:
           COMMANDS[COMMAND_NAMES.index(command)].execute(args, options)
        else:
            print(colored(f'\tERROR: Command "{command}" doesn\'t exist.', 'red'))
    else:
        print(colored('\tERROR: No command passed!', 'red'))
    TOKEN_TYPES.clear()