-- TODO: calculate the column offset, add back opts
local treadmill = {}
local mod = require("zone.helper")
local fake_buf
local local_opts = {headache=false, tick_time=50}

local rotate = function(grid, ns, id)
    for i=0, #grid-1 do
        if grid[i+1][1] ~= "" then
            local item = table.remove(grid[i+1], 1)
            table.insert(grid[i+1], item)
        end
    end

    vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines=grid, id=id })
end

function treadmill.start(opts)
    local_opts = vim.tbl_extend("force", local_opts, opts or {})
    local before_buf = vim.api.nvim_get_current_buf()

    fake_buf = mod.create_and_initiate(nil, local_opts)

    local matrix, ns, id = mod.set_buf_view(before_buf)

    mod.on_each_tick(function() rotate(matrix, ns, id) end)
end

return treadmill
