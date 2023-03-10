import atexit
import os
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
    import readline

    try:
        readline.write_history_file(history)
    except OSError:
        pass


atexit.register(write_history)

del os
del atexit
del readline
