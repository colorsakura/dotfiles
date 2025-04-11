if type -q sudo-rs
    function sudo --description 'Replace sudo with sudo-rs'
        command sudo-rs $argv
    end
end
