TT_COMMAND = 'COMMAND'
TT_ARG = 'ARG'
TT_OPTION = 'OPTION'

class Token:
    def __init__(self, t, value):
        self.type = t
        self.value = value

    def __repr__(self):
        return f'[{self.type}, {self.value}]'