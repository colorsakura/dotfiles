import yaml
import functools
import os
import time
import requests

def metric(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        start = time.time()
        res = func(*args, **kw)
        print('%s executed in %s s' % (func.__name__, time.time() - start))
        return res
    return wrapper

@metric
def get_node(url):
    nodes = {}
    tmp = yaml.safe_load(requests.get(url).text)
    nodes['proxies'] = tmp['proxies']
    nodes['rules'] = tmp['rules']
    nodes['proxy-groups'] = tmp['proxy-groups']
    return nodes

def merge_yaml():
    pass

if __name__ == "__main__":
    # ss_url = os.environ.get('SS_URL')
    ss_url = "https://www.pkqcloud.com/link/RHowYHWRWsmHJA2P?clash=1"
    ss_node = get_node(ss_url)
    base_config = None
    with open('base.yml', 'r') as f:
        base_config = yaml.safe_load(f)
    with open('/etc/clash-meta/config.yaml', 'w+', encoding='utf-8') as f:
        yaml.safe_dump(base_config, f)
        yaml.safe_dump(ss_node, f, allow_unicode=True)
