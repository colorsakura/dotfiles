#!/usr/bin/env python

import functools
import os
import sys
import time

import requests
import yaml


def metric(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        start = time.time()
        res = func(*args, **kw)
        print("%s executed in %s s" % (func.__name__, time.time() - start))
        return res

    return wrapper


@metric
def get_node(url):
    nodes = {}
    tmp = yaml.safe_load(requests.get(url).text)
    nodes["proxies"] = tmp["proxies"]
    # nodes["rules"] = tmp["rules"]
    nodes["proxy-groups"] = tmp["proxy-groups"]
    return nodes


if __name__ == "__main__":
    ss_url = (
        os.environ.get("SS_URL")
        or "https://www.pkqcloud.com/link/RHowYHWRWsmHJA2P?clash=1"
    )
    ss_node = get_node(ss_url)
    base_config = None
    curdir = os.path.dirname(__file__)
    with open(curdir + "/base.yml", "r", encoding="UTF-8") as f:
        base_config = yaml.safe_load(f)

    # 提升到root权限
    if os.geteuid():
        args = [sys.executable] + sys.argv
        # 下面两种写法，一种使用su，一种使用sudo，都可以
        # os.execlp('su', 'su', '-c', ' '.join(args))
        os.execlp("sudo", "sudo", *args)
    with open("/etc/clash-meta/config.yaml", "w+", encoding="utf-8") as f:
        yaml.safe_dump(base_config, f)
        yaml.safe_dump(ss_node, f, allow_unicode=True)
