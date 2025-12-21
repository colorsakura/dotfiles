# 可选参数： -n
function magic --description "启用/禁用 MiHoMo 功能"
    if test "$argv[1]" = -n
        sudo systemctl stop mihomo.service && echo "✅ MiHoMo 已停止" || echo "ℹ️ 无 MiHoMo 功能"
        sudo ip rule del fwmark 1 lookup 100
        sudo ip route del local 0.0.0.0/0 dev lo table 100

        _dns_off
    else
        sudo systemctl start mihomo.service && echo "✅ MiHoMo 已启动" || echo "ℹ️ 无 MiHoMo 功能"
        sudo ip rule add fwmark 1 lookup 100
        sudo ip route add local 0.0.0.0/0 dev lo table 100

        _dns_on
    end
end

function _dns_on
    sudo nft add table inet dns_redir
    sudo nft add chain inet dns_redir prerouting "{ type nat hook prerouting priority -100 ; }"
    sudo nft add chain inet dns_redir output "{ type nat hook output priority -100 ; }"
    sudo nft add rule inet dns_redir prerouting 'meta l4proto {tcp,udp} th dport 53 redirect to :1053'
    sudo nft add rule inet dns_redir output 'meta l4proto {tcp,udp} th dport 53 redirect to :1053'
    echo "✅ DNS 53 → 1053 转发已启用 (prerouting/output)"
end

function _dns_off
    sudo nft delete table inet dns_redir 2>/dev/null || echo "ℹ️ 无 DNS 转发规则"
end
