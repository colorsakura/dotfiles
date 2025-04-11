if type -q fd
    function find
        command fd $argv
    end
end