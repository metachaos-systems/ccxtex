# import erlport modules and functions
from erlport.erlang import set_message_handler, cast
from erlport.erlterms import Atom

handler_pid = None

def register(pid):
    global handler_pid
    handler_pid = pid
    set_message_handler(handler)
    return Atom(b'ok')


def handler(message):
    cast(handler_pid, message)
