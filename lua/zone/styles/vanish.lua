-- FIX: some lines shift, some more cleanify
local vanish = {}
local mod = require("zone.helper")
local fake_buf
local local_opts

local do_stuff = function(grid, ns, id)
    if not vim.api.nvim_buf_is_valid(fake_buf) then
        vim.pretty_print("Buf does not exist")
        return
    end

    local ii = math.random(#grid)
    local jj = math.random(#grid[ii])

    grid[ii][jj] = {' ', '@none'}
    vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, {
        virt_lines=grid, id=id
    })
end

function vanish.start(opts)
    local_opts = opts or {tick_time=50}
    math.randomseed(os.clock())

    local before_buf = vim.api.nvim_get_current_buf()
    fake_buf = mod.create_and_initiate(nil, local_opts)
    local grid, ns, id = mod.set_buf_view(before_buf)

    mod.on_each_tick(function()
        do_stuff(grid, ns, id)
    end)
end

return vanish
