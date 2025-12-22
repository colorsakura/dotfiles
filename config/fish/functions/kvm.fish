function kvm --description "Start KVM virtual machine with fzf selection"
    # Configuration variables
    set -l vm_directory "$HOME/Documents/KVM"
    set -l ovmf_path "/usr/share/edk2-ovmf/x64/OVMF.4m.fd"
    set -l spice_socket_dir "/run/user/(id -u)"

    # Check if required tools are available
    if not type -q qemu-system-x86_64
        echo "Error: qemu-system-x86_64 not found"
        return 1
    end

    if not type -q fd
        echo "Error: fd not found"
        return 1
    end

    if not type -q fzf
        echo "Error: fzf not found"
        return 1
    end

    # Ensure VM directory exists
    if not test -d "$vm_directory"
        echo "Error: VM directory does not exist: $vm_directory"
        return 1
    end

    # Select VM image
    set -l vm (fd --max-depth 1 '(qcow2|img)' "$vm_directory" | fzf --prompt="Select VM > " --height=~50% --layout=reverse --border --exit-0)

    if test -z "$vm"
        echo "No VM selected"
        return 1
    end

    # Validate VM file exists
    if not test -f "$vm"
        echo "Error: VM file does not exist: $vm"
        return 1
    end

    # Generate random identifier for spice socket
    set -l num (openssl rand -base64 8 | tr -dc 'a-zA-Z0-9' | head -c 8)
    set -l spice_socket_path "$spice_socket_dir/$num.spice.sock"

    # Ensure spice socket directory exists
    if not test -d "$spice_socket_dir"
        echo "Error: Spice socket directory does not exist: $spice_socket_dir"
        return 1
    end

    # Validate OVMF firmware exists
    if not test -f "$ovmf_path"
        echo "Error: OVMF firmware not found at: $ovmf_path"
        return 1
    end

    # Start VM with QEMU
    command qemu-system-x86_64 -enable-kvm \
        -cpu host -smp 6 -m 8G \
        -machine q35 -device intel-iommu \
        -drive if=pflash,format=raw,readonly=on,file="$ovmf_path" \
        -drive file="$vm",if=virtio \
        -netdev user,id=vmnic,hostname=archvm,hostfwd=tcp::2222-:22 \
        -device virtio-net,netdev=vmnic \
        -usb -device usb-tablet -device virtio-vga-gl \
        -display egl-headless,gl=on \
        -spice unix=on,addr="$spice_socket_path",disable-ticketing=on \
        -device virtio-serial-pci \
        -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
        -chardev spicevmc,id=spicechannel0,name=vdagent &

    # Start SPICE client
    if type -q spicy
        command spicy --uri="spice+unix://$spice_socket_path" >/dev/null 2>&1 &
    else
        echo "Warning: spicy not found, VM started but no display client available"
    end

    echo "VM started with spice socket: $spice_socket_path"
end
