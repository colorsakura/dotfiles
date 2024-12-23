local wezterm = require 'wezterm'
local config = {
  color_scheme = 'Github Dark',
  font = wezterm.font('JetBrains Mono', {})
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'powershell.exe' }
end

return config
