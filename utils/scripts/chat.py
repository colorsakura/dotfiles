#!/bin/env python3

import argparse
import functools
import time

import openai

# openai.api_key = os.getenv("OPENAI_API_KEY") \
    # or "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"
openai.api_base = "https://api.openai-proxy.com/v1"

messages = []

def consume(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        # 原函数运行前
        start_time = time.time()
        value = func(*args, **kwargs)
        # 原函数运行后
        print("{}: const {}s".format(value, (time.time() - start_time)))
        return value
    return wrapper

def usage():
    print()

def options():
    parser = argparse.ArgumentParser(description="Just an example",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-s", "--shell", help="shell mode")
    parser.add_argument("-v", "--verbose", action="store_true", help="increase verbosity")
    parser.add_argument("-B", "--block-size", help="checksum blocksize")
    parser.add_argument("--ignore-existing", action="store_true", help="skip files that exist")
    parser.add_argument("--exclude", help="files to exclude")
    parser.add_argument("content", help="content")
    global args 
    args = parser.parse_args()

@consume
def chat():
    response = openai.ChatCompletion.create(
        model = "gpt-3.5-turbo-16k",
        messages = [
            {"role": "user", "content": args.content},
        ]
    )
    return response

if __name__ == '__main__':
    options()
    chat()
