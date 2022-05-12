import os
import atexit
import readline

history = os.path.join(
    os.path.expanduser(os.environ["XDG_DATA_HOME"]),
    "python",
    "python_history",
)
os.makedirs(os.path.dirname(history), exist_ok=True)

try:
    readline.read_history_file(history)
except OSError:
    pass

def write_history():
    try:
        readline.write_history_file(history)
    except OSError:
        pass

atexit.register(write_history)
