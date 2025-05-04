#!/bin/bash
app=$1
shift
systemd-run --user --unit=${FUZZEL_DESKTOP_FILE_ID}@${RANDOM} -- ${app} $@