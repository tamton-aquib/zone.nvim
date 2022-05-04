-- TODO: fix the spacing stuff
local treadmill = {}
local mod = require("zone.helper")
local fake_buf
local opts_table

local line_spaces

local rotate = function()
    if not vim.api.nvim_buf_is_valid(fake_buf) then return end
	local lines = vim.api.nvim_buf_get_lines(fake_buf, 0, -1, true)
	local new_lines = {}
	for i, line in ipairs(lines) do
		local spaces = line_spaces[i]
		local clean_line = vim.trim(line)
        local new_line
        local dir = opts_table and opts_table.direction or "left"
        if dir == "right" then
            new_line = spaces .. clean_line:sub(-1, -1) .. clean_line:sub(1, -2)
        else
            new_line = spaces .. clean_line:sub(2, -1) .. clean_line:sub(1, 1)
        end
		table.insert(new_lines, new_line)
	end

    vim.schedule(function()
        vim.api.nvim_buf_set_lines(fake_buf, 0, -1, true, new_lines)
    end)
end

function treadmill.start(opts)
    opts_table = opts
    fake_buf = mod.create_and_initiate(nil)
    local before_buf = vim.api.nvim_get_current_buf()
    local start_line = vim.fn.line("w0") - 1
    local end_line = start_line + vim.o.lines

    local local_content = vim.api.nvim_buf_get_lines(before_buf, start_line, end_line, false)
    vim.api.nvim_buf_set_lines(fake_buf, 0, -1, true, local_content)

    line_spaces = {}
    for _,line in ipairs(vim.api.nvim_buf_get_lines(fake_buf, 0, -1, true)) do
        local this_line = line:match("^(%s*)") or ""
        table.insert(line_spaces, this_line)
    end

    mod.on_each_tick(vim.schedule_wrap(rotate))
end

return treadmill
