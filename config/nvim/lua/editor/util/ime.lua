local M = {}

function M.init()
    if vim.env.SSH_TTY then return end

    local os_name = (vim.uv or vim.loop).os_uname().sysname
    if
        (os_name == "Linux" or os_name == "Unix")
        and os.getenv "DISPLAY" == nil
        and os.getenv "WAYLAND_DISPLAY" == nil
    then
        return
    end

    -- check fcitx-remote (fcitx5-remote)
    local fcitx_cmd = ""
    if vim.fn.executable "fcitx-remote" == 1 then -- This can stay as vim.fn.executable for efficiency
        fcitx_cmd = "fcitx-remote"
    elseif vim.fn.executable "fcitx5-remote" == 1 then -- This can stay as vim.fn.executable for efficiency
        fcitx_cmd = "fcitx5-remote"
    end
    M.fcitx_cmd = fcitx_cmd
end

-- 使用 vim.b 可以记录每个buffer的输入法状态

function M.check()
    -- Rewritten using vim.system
    if not M.fcitx_cmd or M.fcitx_cmd == "" then return end
    vim.system({ M.fcitx_cmd }, { text = true }, function(obj)
        if obj.code == 0 and obj.stdout then
            -- Trim potential whitespace/newline from stdout
            local output = vim.trim(obj.stdout)
            local input_status = tonumber(output)
            if input_status == 1 then
                vim.b.ime = false
            elseif input_status == 2 then
                vim.b.ime = true
            end
        else
            vim.notify(
                "Failed to check fcitx status. Code: " .. tostring(obj.code) .. ", Signal: " .. tostring(obj.signal),
                vim.log.levels.WARN
            )
        end
    end)
end

function M.Fcitx2en()
    -- Rewritten using vim.system
    if not M.fcitx_cmd or M.fcitx_cmd == "" then return end
    vim.system({ M.fcitx_cmd }, { text = true }, function(obj)
        if obj.code == 0 and obj.stdout then
            local output = vim.trim(obj.stdout)
            local input_status = tonumber(output)
            if input_status == 2 then
                vim.b.input_toggle_flag = true
                -- Execute the second command inside the callback of the first
                vim.system({ M.fcitx_cmd, "-c" }, { text = true }, function(switch_obj)
                    if switch_obj.code ~= 0 then
                        vim.notify(
                            "Failed to switch fcitx off. Code: "
                                .. tostring(switch_obj.code)
                                .. ", Signal: "
                                .. tostring(switch_obj.signal),
                            vim.log.levels.WARN
                        )
                    end
                end)
            end
        else
            vim.notify(
                "Failed to check fcitx status before switching off. Code: "
                    .. tostring(obj.code)
                    .. ", Signal: "
                    .. tostring(obj.signal),
                vim.log.levels.WARN
            )
        end
    end)
end

function M.Fcitx2NonLatin()
    -- Rewritten using vim.system
    if not M.fcitx_cmd or M.fcitx_cmd == "" then return end
    if vim.b.input_toggle_flag == nil then
        vim.b.input_toggle_flag = false
    elseif vim.b.input_toggle_flag == true then
        vim.system({ M.fcitx_cmd, "-o" }, { text = true }, function(obj)
            if obj.code == 0 then
                vim.b.input_toggle_flag = false
            else
                vim.notify(
                    "Failed to switch fcitx on. Code: " .. tostring(obj.code) .. ", Signal: " .. tostring(obj.signal),
                    vim.log.levels.WARN
                )
            end
        end)
    end
end

function M.setup()
    M.init()
    if M.fcitx_cmd == nil or M.fcitx_cmd == "" then -- Added check for empty string
        -- vim.notify "你的输入法暂时不支持自动切换"
        return
    end

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

return M
