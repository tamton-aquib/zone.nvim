-- TODO: add character mode instead of line mode
local epilepsy = {}
local ns = vim.api.nvim_create_namespace('epilepsy')
local mod = require("zone.helper")
local fake_buf

-- local map = { 'orange', 'red', 'cyan', 'brown', 'magenta', 'gray', 'white' } --black
-- The palette
local map = {
    "#11121D", "#a0A8CD", "#32344a", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#ad8ee6", "#449dab",
    "#787c99", "#444b6a", "#ff7a93", "#b9f27c", "#ff9e64", "#7da6ff", "#bb9af7", "#0db9d7", "#acb0d0"
}

epilepsy.start = function()
    local before_buf = vim.api.nvim_get_current_buf()

    fake_buf = mod.create_and_initiate(nil)

    mod.set_buf_view(before_buf)

    mod.on_each_tick(function()
        for i=0, #map do
            local color = map[math.ceil(math.random() * #map)]
            -- vim.api.nvim_set_hl(ns, 'Epilepsy'..i, {fg=color})
            vim.cmd("hi Epilepsy"..i.." guifg="..color.." guibg=none")
        end

        for i=0,vim.api.nvim_buf_line_count(fake_buf) do
            -- local l = vim.api.nvim_buf_get_lines(fake_buf, i, i+1, false)
            -- for j=0, #l do
                local hl = "Epilepsy"..math.ceil(math.random() * #map)
                -- vim.api.nvim_buf_add_highlight(fake_buf, ns, hl, i, j, j+1)
            vim.api.nvim_buf_add_highlight(fake_buf, ns, hl, i, 0, -1)
            -- end
        end
    end)
end

return epilepsy
