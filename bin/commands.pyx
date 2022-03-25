import os
import getpass
from termcolor import colored

COMMANDS = []
COMMAND_NAMES = []
class Command:
    def __init__(self, name, desc, func):
        self.name = name
        self.desc = desc
        self.func = func
        COMMAND_NAMES.append(self.name)
        COMMANDS.append(self)

    def execute(self, args, options):
        self.func(args, options)

    def __repr__(self):
        return f'\t{colored(self.name, "cyan")}: \n\t\t{colored(self.desc, "magenta")}\n'

def hlp(args, options):
    for command in COMMANDS:
        print(command)

def ls(args, options):
    showHiddenFolders = False if '-h' in options else True
    if len(args) > 0:
        try:
            for folder in os.listdir(args[0].value.replace('"', '')):
                if not showHiddenFolders:
                    if not folder[0] is '.':
                        print(f'\t{folder}')
                else:
                    print(f'\t{folder}')
        except FileNotFoundError:
            print(colored(f'\tERROR: the file {args[0].value} was not found', 'red'))
    else:
        for folder in os.listdir(os.getcwd()):
            if not showHiddenFolders:
                if not folder[0] is '.':
                    print(f'\t{folder}')
            else:
                print(f'\t{folder}')

def cd(args, options):
    if len(args) == 0:
        print(colored('\tERROR: Expected ARG but got none', 'red'))
        return
    try:
        if args[0].value == '~' or args[0].value == '"~"':
            os.chdir('C:\\Users\\' + getpass.getuser())
        else:
            os.chdir(args[0].value.replace('"', ''))
    except FileNotFoundError:
        try:
            os.chdir(os.getcwd() + '\\' + args[0].value.replace('"', ''))
        except FileNotFoundError:
            print(colored(f'\tERROR: the file {args[0].value} was not found', 'red'))

def rmdir(args, options):
    path = args[0].value if len(args) > 0 else None
    if path is None:
        print(colored('\tERROR: Expected ARG but got none', 'red'))
        return
    try:
        os.rmdir(path.replace('"', ''))
    except FileNotFoundError:
        try:
            os.rmdir(os.getcwd() + '\\' + args[0].value.replace('"', ''))
        except FileNotFoundError:
            print(colored(f'\tERROR: the folder {args[0].value} was not found', 'red'))
        except NotADirectoryError:
            print(colored(f'\tERROR: the path {path} was not a folder', 'red'))
    except NotADirectoryError:
        print(colored(f'\tERROR: the path {path} was not a folder', 'red'))


def create_commands():
    Command('help', 'Lists all the commands built into Z-SHELL', hlp)
    Command('ls', 'List all the directories in a filetakes 1 optional of arg of a path, '
                  'if not provided it will list\n\t\tthe current folders of the current directory. The -h option will hide '
                  'hidden folders', ls)
    Command('cd', 'Changes Directory Required PATH argument takes no options', cd)
    Command('rmdir', 'Removes Directory Required PATH argument takes no options', rmdir)
