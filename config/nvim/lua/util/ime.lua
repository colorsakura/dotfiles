local Job = require "plenary.job"

local M = {}

-- check fcitx-remote (fcitx5-remote)
local fcitx_cmd = ""
if vim.fn.executable "fcitx-remote" == 1 then      -- This can stay as vim.fn.executable for efficiency
	fcitx_cmd = "fcitx-remote"
elseif vim.fn.executable "fcitx5-remote" == 1 then -- This can stay as vim.fn.executable for efficiency
	fcitx_cmd = "fcitx5-remote"
end

if os.getenv "SSH_TTY" ~= nil then return end

local os_name = vim.loop.os_uname().sysname
if (os_name == "Linux" or os_name == "Unix") and os.getenv "DISPLAY" == nil and os.getenv "WAYLAND_DISPLAY" == nil then
	return
end

-- 使用 vim.b 可以记录每个buffer的输入法状态

function M.check()
	Job:new({
		command = fcitx_cmd,
		on_exit = function(j, _, _)
			local input_status = tonumber(j:result()[1])
			if input_status == 1 then
				vim.b.ime = false
			elseif input_status == 2 then
				vim.b.ime = true
			end
		end,
	}):start()
end

function M.Fcitx2en()
	Job:new({
		command = fcitx_cmd,
		on_exit = function(j, _, _)
			local input_status = tonumber(j:result()[1])
			if input_status == 2 then
				vim.b.input_toggle_flag = true
				Job:new({ command = fcitx_cmd, args = { "-c" } }):start()
			end
		end,
	}):start()
end

function M.Fcitx2NonLatin()
	if vim.b.input_toggle_flag == nil then
		vim.b.input_toggle_flag = false
	elseif vim.b.input_toggle_flag == true then
		Job:new({ command = fcitx_cmd, args = { "-o" } }):start()
		vim.b.input_toggle_flag = false
	end
end

function M.setup()
	if fcitx_cmd == "" then
		vim.notify "你的输入法暂时不支持自动切换"
	else
		local group = vim.api.nvim_create_augroup("Fcitx", { clear = true })
		vim.api.nvim_create_autocmd("InsertEnter", {
			group = group,
			callback = function() M.Fcitx2NonLatin() end,
		})
		vim.api.nvim_create_autocmd("InsertLeave", {
			group = group,
			callback = function() M.Fcitx2en() end,
		})
	end
end

return M
