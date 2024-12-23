import subprocess
import tempfile


def download():
    url = "https://github.com/colorsakura/dotfiles"
    tmp = tempfile.gettempdir()
    subprocess.run(["git clone {}".format(url)])


if __name__ == "__main__":
    import sys

    match sys.platform:
        case "linux":
            print(sys.platform)
        case "windows":
            print(sys.platform)
        case "darwin":
            print(sys.platform)
