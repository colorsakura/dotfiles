function kvm
    set -l vm (fd --max-depth 1 '(qcow2|img)' ~/Documents/KVM | fzf --prompt="Select VM > " --height=~50% --layout=reverse --border --exit-0)

    if test -z "$vm"
        echo "No vm selected"
        return
    end

    set -l num (openssl rand -base64 8 | tr -dc 'a-zA-Z0-9' | head -c 8)

    command qemu-system-x86_64 -enable-kvm \
        -cpu host -smp 6 -m 8G \
        -machine q35 -device intel-iommu \
        -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF.4m.fd \
        -drive file="$vm",if=virtio \
        -netdev user,id=vmnic,hostname=archvm,hostfwd=tcp::2222-:22 \
        -device virtio-net,netdev=vmnic \
        -usb -device usb-tablet -device virtio-vga-gl \
        -display egl-headless,gl=on \
        -spice unix=on,addr="/run/user/1000/$num.spice.sock",disable-ticketing=on \
        -device virtio-serial-pci \
        -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
        -chardev spicevmc,id=spicechannel0,name=vdagent &

    command spicy --uri="spice+unix:///run/user/1000/$num.spice.sock" >/dev/null 2>&1 &
end
