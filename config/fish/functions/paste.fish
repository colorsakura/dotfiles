function paste --description "Paste to web"
    command curl --data-binary @- https://paste.rs/ $argv
end
