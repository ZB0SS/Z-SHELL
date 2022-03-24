from string import ascii_letters, printable
import pyximport
pyximport.install()
from tokens import *

LETTERS = ascii_letters

TOKENS = []
class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = -1
        self.currentChar = None
        self.commandPassed = False
        self.advance()

    def advance(self):
        self.pos += 1
        self.currentChar = self.text[self.pos] if self.pos < len(self.text) else None

    def make_tokens(self):
        # Clear from the last command
        TOKENS.clear()
        while self.currentChar is not None:
            if self.currentChar in LETTERS:
                if not self.commandPassed:
                    token = self.makeCommand()
                    if token is not None: TOKENS.append(token)
                    self.advance()
                else:
                    token = self.makeArgs()
                    if token is not None: TOKENS.append(token)
                    self.advance()
            elif self.currentChar == ' ':
                self.advance()
            elif self.currentChar == '"':
                self.advance()
                token = self.makeStringArg()
                # if the string doesn't end with "
                if token is not None:
                    TOKENS.append(token)
                    self.advance()
            elif self.currentChar == '-':
                token = self.makeOption()
                TOKENS.append(token)
            else:
                token = self.makeArgs()
                TOKENS.append(token)
                self.advance()
        return TOKENS


    def makeCommand(self):
        command = ''
        while str(self.currentChar) in LETTERS:
            command += self.currentChar
            self.advance()

        # Checks to see if the command ends properly
        if self.currentChar is not None:
            self.commandPassed = True
            if self.currentChar is ' ':
                pass
            else:
                print('Invalid Syntax')
                TOKENS.clear()
                return None
        self.pos -= 1
        token = Token(TT_COMMAND, command)
        self.commandPassed = True
        return token

    def makeArgs(self):
        arg = ''
        while str(self.currentChar) in printable:
            if self.currentChar == ' ':
                self.pos -= 1
                return Token(TT_ARG, arg)
            arg += str(self.currentChar)
            self.advance()

        # Checks to see if the arg ends properly
        self.pos -= 1

        token = Token(TT_ARG, arg)
        self.commandPassed = True
        return token

    def makeStringArg(self):
        arg = '"'
        while self.currentChar is not None:
            arg += self.currentChar
            if self.currentChar == '"':
                return Token(TT_ARG, arg)
            self.advance()
        print("ERROR: String didn't end with '\"'")
        TOKENS.clear()
        return None

    def makeOption(self):
        option = ''
        while self.currentChar is not None:
            if self.currentChar == ' ':
                return Token(TT_OPTION, option)
            option += self.currentChar
            self.advance()
        return Token(TT_OPTION, option)

