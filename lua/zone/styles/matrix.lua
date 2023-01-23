-- TODO: cant quite figure out the algorithm for this style.
local matrix = {}
local fake_buf, fake_win, local_opts
local chars = vim.split("qwe rty uiop asda fghjkl zxc vbnmQWE  RTYU IOPASDF GHJ KL ZXCVBNM12 3456 7890!@ #$ %^&*(){}[]\\' \"; :,>/.", '')
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
        counter = 1
    end

    table.remove(grid, #grid)
    local last = {}
    for _=1, vim.o.columns do
        table.insert(last, {' ', 'Green'})

        local desired_char = chars[math.random(#chars)]
        -- TODO: cleanify
        -- if counter < 3 and counter > 0 then
            -- table.insert(last, {desired_char, 'LightestGreen'})
        -- elseif counter < 6 and counter > 3 then
            -- table.insert(last, {desired_char, 'LighterGreen'})
        -- elseif counter < 9 and counter > 6 then
            -- table.insert(last, {desired_char, 'LightGreen'})
        -- else
            -- table.insert(last, {desired_char, 'Green'})
        -- end
        table.insert(last, {desired_char, 'LightGreen'})
    end

    table.insert(grid, 1, last)
    counter = counter + 1

    vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines=grid, id=id })
end

matrix.start = function()
    vim.cmd [[hi Black guifg=#000000]]
    vim.cmd [[hi Green guifg=#008000]]
    vim.cmd [[hi LightGreen guifg=#00ff00]]
    vim.cmd [[hi LighterGreen guifg=#00ff00]]
    vim.cmd [[hi LightestGreen guifg=#00ff00]]
    fake_buf, _ = mod.create_and_initiate(nil, local_opts)
    -- vim.api.nvim_win_set_option(fake_win, 'winhighlight', 'Normal:Black')

    local grid = {}
    for i = 1, vim.o.lines do
        grid[i] = {}
        for j = 1, vim.o.columns do
            -- grid[i][j] = {chars[math.random(#chars)], '@function'}
            grid[i][j] = {chars[math.random(#chars)+50] or ' ', 'LightGreen'}
        end
    end

    local id = vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines = grid })

    mod.on_each_tick(function() do_stuff(grid, id) end, 100)
end

return matrix
