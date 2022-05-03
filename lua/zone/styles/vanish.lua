local vanish = {}
local mod = require("zone.helper")
local buf_dup

local do_stuff = function(lines)
    local random_line_idx = math.random(#lines)
    local random_line = lines[random_line_idx]

    if random_line ~= "" then
        local letters = vim.split(random_line, '')
        local random_letter_idx = math.random(#letters)
        if letters[random_letter_idx] ~= " " then
            letters[random_letter_idx] = " "
            local new_line = table.concat(letters, '')
            lines[random_line_idx] = new_line
            -- TODO: for efficiency, just change the single line
            -- vim.api.nvim_buf_set_lines(buf_dup, 0, -1, true, lines)
            if vim.api.nvim_buf_is_valid(buf_dup) then
                vim.api.nvim_buf_set_lines(buf_dup, random_line_idx-1, random_line_idx, true, {new_line})
            end
        end
    end
end

function vanish.start()
    mod.opts = {tick_time=10}
    local buf_og = vim.api.nvim_get_current_buf()
    math.randomseed(os.clock())

    local start_line = vim.fn.line("w0") - 1
    local end_line = start_line + vim.o.lines

    local lines = vim.api.nvim_buf_get_lines(buf_og, start_line, end_line, false)
    buf_dup = mod.create_and_initiate(nil)
    vim.api.nvim_buf_set_lines(buf_dup, 0, -1, false, lines)

    mod.on_each_tick(function()
        do_stuff(lines)
    end)
end

return vanish
