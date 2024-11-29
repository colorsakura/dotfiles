import os
import subprocess

pwd = os.path.split(os.path.realpath(__file__))[0]

def load_conf(path):
    content = []
    try:
        with open(path, mode='r') as f:
            lines = f.readlines()
            for line in lines:
                if line.startswith('#'):
                    pass
                else:
                    content.append(line.strip())
    except FileNotFoundError:
        print(f"Configuration file not found at {path}")
    print(content)
    return content


# TODO: 需要区分已安装和安装失败
def run(pkg) -> bool:
    print(f"Installing {pkg}")
    return subprocess.run(["winget", "install", pkg]).returncode == 0


def sumary(status):
    pass


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Setup')
    parser.add_argument('-c', '--config_file', default=os.path.join(pwd, "windows.pkg"), help='Configuration file')
    args = parser.parse_args()

    status ={}

    pkgs = load_conf(args.config_file)
    for pkg in pkgs:
        status[pkg] = run(pkg)

    print(status)
