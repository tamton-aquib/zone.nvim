-- FIX: some lines shift, some more cleanify
local vanish = {}
local fake_buf
local local_opts

local mod = require("zone.helper")

vanish.setup = function(o) local_opts = o end

local do_stuff = function(matrix, ns, id)
    local rand_row = math.random(#matrix)
    local rand_col = math.random(#matrix[rand_row])

    if matrix[rand_row][rand_col][1] ~= "" then
        matrix[rand_row][rand_col] = {' ', '@none'}
    end
    vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines=matrix, id=id })
end

function vanish.start()
    math.randomseed(os.clock())

    local before_buf = vim.api.nvim_get_current_buf()

    fake_buf = mod.create_and_initiate(nil, local_opts)

    local matrix, ns, id = mod.set_buf_view(before_buf)

    mod.on_each_tick(function() do_stuff(matrix, ns, id) end)
end

return vanish
