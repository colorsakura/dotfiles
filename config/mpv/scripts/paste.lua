--[[
Add 'paste' command that plays the file path present in the Wayland
clipboard. Bind 'paste' command to 'Ctrl+v'.

See Also:
 - https://www.reddit.com/r/swaywm/comments/qieita/trying_to_drag_and_drop_youtube_links_from/
--]]
mp = require 'mp'
function paste()
    local clipboard = mp.command_native{
        name = 'subprocess',
	playback_only = false,
        args = {'wl-paste', '--no-newline'},
        capture_stdout = true
    }.stdout
    mp.commandv('loadfile', clipboard)
end
mp.add_key_binding('Ctrl+v', 'paste', paste)
