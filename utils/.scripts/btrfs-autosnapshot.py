#!/usr/bin/python3

import contextlib
import ctypes
import datetime
import logging
import os
import subprocess
import tempfile
from pathlib import Path

# TODO:
DEV = '/dev/nvme0n1p2'  # 硬盘
SYSROOT = Path('/')     # 根目录
SNAPSHOT_ROOT = Path('/.snapshots')     # 快照目录
CLONE_NEWNS = 0x20000

logger = logging.getLogger(__name__)


def run_cmd(cmd) -> None:
    logger.debug('running cmd: %r', cmd)
    if cmd[0] == 'btrfs':
        subprocess.check_call(cmd, stdout=subprocess.DEVNULL)
    else:
        subprocess.check_call(cmd)


def may_snapshot(path, name, path_name) -> None:
    """create snapshot

    """
    path = path.lstrip('/')
    dst = SNAPSHOT_ROOT / path_name / name

    if not dst.is_dir():
        dir = SNAPSHOT_ROOT / path_name
        if not dir.exists():
            dir.mkdir()

        src = SYSROOT / path
        cmd = ['btrfs', 'subvolume', 'snapshot', '-r',
               src, dst]
        run_cmd(cmd)


def cleanup(path, path_name, nkeep, suffix) -> None:
    snapshots = [x for x in (SNAPSHOT_ROOT / path_name).iterdir()
                 if x.name.endswith(suffix)]
    snapshots.sort()
    logger.info('known snapshots for path %r (%r): %r',
                path, path_name, [str(x) for x in snapshots])

    to_remove = snapshots[:-nkeep]
    for name in to_remove:
        cmd = ['btrfs', 'subvolume', 'delete', name]
        run_cmd(cmd)


@contextlib.contextmanager
def setup():
    libc = ctypes.CDLL('libc.so.6', use_errno=True)
    ret = libc.unshare(CLONE_NEWNS)
    if ret != 0:
        errno = ctypes.get_errno()
        raise OSError(errno, 'unshare failed')

    cmd = ['mount', '--make-rprivate', '/']
    run_cmd(cmd)

    cwd = os.getcwd()
    tmpdir = tempfile.mkdtemp(prefix='btrfs-snapshot-')

    cmd = ['mount', '-o', 'compress=zstd,subvol=/',
           DEV, tmpdir]
    run_cmd(cmd)

    os.chdir(tmpdir)
    yield

    os.chdir(cwd)
    cmd = ['umount', tmpdir]
    run_cmd(cmd)
    os.rmdir(tmpdir)


def main():
    import argparse
    parser = argparse.ArgumentParser(
        description='automatically keep snapshots for btrfs',
    )
    parser.add_argument('-n', '--nkeep', type=int,
                        help='keep n snapshots')
    parser.add_argument('-f', '--format', default='%Y-%m-%d-%H',
                        help='datetime format for snapshot names')
    parser.add_argument('filesystem', nargs='+',
                        help='filesystems to do snapshots')
    args = parser.parse_args()

    suffix = '-auto'
    dt = datetime.datetime.now()
    name = '{dt}{suffix}'.format(
        dt=dt.strftime(args.format), suffix=suffix)

    with setup():
        for path in sorted(args.filesystem):
            path_name = path.strip('/').replace('-', '--').replace('/', '-')

            # filesystem root
            if not path_name:
                path_name = '-'
            may_snapshot(path, name, path_name)

            if args.nkeep:
                cleanup(path, path_name, args.nkeep, suffix)


if __name__ == '__main__':
    main()

# vim: set ts=4 noet:
