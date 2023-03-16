

def read_yaml(args):
    content = ""
    for arg in args.source:
        for line in open(arg, 'r'):
            line = line.split('\t')
            if len(line) == 3:
                line[1] = line[1].replace(' ', "'")
                content += line[0] + ' ' + line[1] + ' ' + '0\n'

    with open(args.target, 'w') as f:
        f.write(content)


def parser_dict():
    pass


def write_txt():
    pass


def main():
    import argparse
    parser = argparse.ArgumentParser(
        description="Translate rime yaml dict to fcitx5 pinyin txt;"
    )
    parser.add_argument('-s', '--source', type=str,
                        nargs='+', help='source file')
    parser.add_argument('-t', '--target', type=str,
                        default='output.txt', help='target file')
    args = parser.parse_args()

    print(args)
    read_yaml(args)


if __name__ == '__main__':
    main()
