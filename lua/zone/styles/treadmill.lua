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
    local before_buf = vim.api.nvim_get_current_buf()

    fake_buf = mod.create_and_initiate(nil)

    local zone_lines = mod.set_buf_view(before_buf)

    line_spaces = {}
    for _,line in ipairs(zone_lines) do
        local this_line = line:match("^(%s*)") or ""
        table.insert(line_spaces, this_line)
    end

    mod.on_each_tick(rotate)
end

return treadmill
