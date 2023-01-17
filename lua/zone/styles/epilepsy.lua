-- TODO: add character mode instead of line mode
-- NOTE: opts: stage: ['aura', 'ictal']
local epilepsy = {}
local mod = require("zone.helper")
local local_opts = { stage="aura" }
local fake_buf

-- The palette
-- TODO: avoid this and take colors directly from current colorscheme
-- local map = { 'orange', 'red', 'cyan', 'brown', 'magenta', 'gray', 'white' } --black
local map = {
    "#11121D", "#a0A8CD", "#32344a", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#ad8ee6", "#449dab",
    "#787c99", "#444b6a", "#ff7a93", "#b9f27c", "#ff9e64", "#7da6ff", "#bb9af7", "#0db9d7", "#acb0d0"
}

local do_stuff = function(matrix, ns, id)
    for row=0, #matrix-1 do
        local line = matrix[row+1]

        if line ~= nil then
            if local_opts.stage == "aura" then
                for col=1, #line do
                    local hl = "Epilepsy"..math.ceil(math.random() * #map)
                    line[col][2] = hl
                end
            elseif local_opts.stage == "ictal" then
                local hl = "Epilepsy"..math.ceil(math.random() * #map)
                for c=1, #line do
                    line[c][2] = hl
                end
            else
                vim.notify("Not a valid stage!")
            end
        end
    end

    vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines = matrix, id=id })
end

epilepsy.start = function(opts)
    local_opts = opts or { stage="aura" }
    local before_buf = vim.api.nvim_get_current_buf()

    fake_buf = mod.create_and_initiate(nil, local_opts)

    local matrix, ns, id = mod.set_buf_view(before_buf)

    for i=0, #map do
        local color = map[math.ceil(math.random() * #map)]
        -- TODO: change to new hl api's
        -- vim.api.nvim_set_hl(ns, 'Epilepsy'..i, {fg=color})
        vim.cmd("hi Epilepsy"..i.." guifg="..color.." guibg=none")
    end

    mod.on_each_tick(function() do_stuff(matrix, ns, id) end)
end

return epilepsy
