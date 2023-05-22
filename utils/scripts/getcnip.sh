#!/bin/sh
curl -O http://ftp.apnic.net/stats/apnic/delegated-apnic-latest
cat delegated-apnic-latest | awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' | cat > /home/chauncey/.scripts/cn_rules.conf
cat cn_rules.conf|sed ':label;N;s/\n/, /;b label'|sed 's/$/& }/g'|sed 's/^/{ &/g' > /home/chauncey/.scripts/cn_rules1.conf
