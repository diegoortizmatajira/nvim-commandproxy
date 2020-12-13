local api = vim.api

if vim.g.commandproxy_commands == nil then
    vim.g.commandproxy_commands = {}
end

local M = {}

function M.register_implementation(lang, command, implementation)
    local commands = vim.g.commandproxy_commands
    if commands[command] == nil then
        commands[command] = {}
    end
    if commands[command][lang] == nil then
        commands[command][lang] = ""
    end
    commands[command][lang] = implementation
    vim.g.commandproxy_commands = commands
end

function M.register_implementations(lang, implementations)
    for key, value in pairs(implementations) do
        M.register_implementation(lang, key, value)
    end
end

function M.execute_command(command)
    local filetype = vim.bo.filetype
    if vim.g.commandproxy_commands[command] ~= nil then
        if vim.g.commandproxy_commands[command][filetype] ~= nil then
            api.nvim_command(vim.g.commandproxy_commands[command][filetype])
            return
        elseif vim.g.commandproxy_commands[command]["*"] ~= "" then
            api.nvim_command(vim.g.commandproxy_commands[command]["*"])
            return
        end
    end
    api.nvim_command("echo '[" .. command .."] command is not implemented for the file type [" .. filetype .. "]'")
    return
end

function M.register_commands(commands)
    for key, value in pairs(commands) do
        api.nvim_command("command! " .. key .. " lua require 'nvim-commandproxy'.execute_command('".. key .. "')")
        M.register_implementation("*", key, value)
    end
end

return M
