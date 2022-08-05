local vanish = {}
local mod = require("zone.helper")
local fake_buf

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
            if vim.api.nvim_buf_is_valid(fake_buf) then
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(fake_buf, random_line_idx-1, random_line_idx, true, {new_line})
                end)
            end
        end
    end
end

function vanish.start()
    mod.opts = {tick_time=70}
    math.randomseed(os.clock())

    local before_buf = vim.api.nvim_get_current_buf()
    fake_buf = mod.create_and_initiate(nil)
    local lines = mod.set_buf_view(before_buf)

    mod.on_each_tick(function()
        do_stuff(lines)
    end)
end

return vanish
