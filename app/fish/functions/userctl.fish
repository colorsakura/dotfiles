function userctl --wraps 'systemctl --user' --description "systemctl --user wrapper"
  systemctl --user $argv
end
