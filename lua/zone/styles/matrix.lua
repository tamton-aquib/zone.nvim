-- TODO: cant quite figure out the algorithm for this style.
local matrix = {}
local fake_buf, local_opts
local chars = vim.split("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!@#$%^&*(){}[]\\'\"; :,>/.", '')
local ns = vim.api.nvim_create_namespace("zone-matrix")

local mod = require("zone.helper")

matrix.setup = function(o) local_opts = o end

local avoid_positions
local counter=1
local generate_random_positions = function()
    local poss = {}
    for _=1,math.floor((vim.o.columns*3)/5) do
        local item = math.random(vim.o.columns)
        table.insert(poss, item)
    end

    return poss
end
local do_stuff = function(grid, id)
    if counter % 13 == 0 or not avoid_positions then
        avoid_positions = generate_random_positions()
    end

    table.remove(grid, #grid)
    local last = {}
    for i=1, vim.o.columns do
        if vim.tbl_contains(avoid_positions, i) then
            table.insert(last, {' ', '@function'})
        else
            table.insert(last, {chars[math.random(#chars)], '@function'})
        end
    end

    table.insert(grid, 1, last)
    counter = counter + 1

    vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines=grid, id=id })
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

    local id = vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines = grid })

    mod.on_each_tick(function() do_stuff(grid, id) end)
end

return matrix
