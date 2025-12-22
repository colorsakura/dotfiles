# Create a find function that uses fd if available, otherwise falls back to system find
if type -q fd
    function find --wraps=fd --description "Find files using fd"
        command fd $argv
    end
else
    function find --wraps=command find --description "Find files using system find"
        command find $argv
    end
end