local matrix = {}
local fake_buf, local_opts
local chars = vim.split("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!@#$%^&*(){}[]\\'\";:,>/.", '')
local ns = vim.api.nvim_create_namespace("zone-matrix")

local mod = require("zone.helper")

matrix.setup = function(o) local_opts = o end

local do_stuff = function(grid, id)
    -- Logic goes here

    -- vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines=grid, id=id })
end

matrix.start = function()
    fake_buf = mod.create_and_initiate(nil, local_opts)

    local grid = {}
    for i = 1, vim.o.lines do
        grid[i] = {}
        for j = 1, vim.o.columns do
            grid[i][j] = {chars[math.random(#chars)], '@function'}
        end
    end

    -- vim.pretty_print(grid)
    local id = vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, {
        virt_lines = grid
    })

    mod.on_each_tick(function() do_stuff(grid, id) end)
end

return matrix
