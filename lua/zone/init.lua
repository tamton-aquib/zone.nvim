local zone = {}
local timer
-- local zone_loaded = false

local default_opts = require("zone.config")

local counter = 1
zone.setup = function(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    local grp = vim.api.nvim_create_augroup('Zone', {clear=true})
    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = grp,
        callback = function()
            if (timer and timer:is_active()) then
                counter = counter + 1
                vim.pretty_print("Timer already running!", counter)
                return
            end
            if vim.tbl_contains(opts.exclude_filetypes, vim.bo.ft) then return end
            if vim.tbl_contains(opts.exclude_buftypes, vim.bo.bt) then return end

            timer = vim.loop.new_timer()
            timer:start(opts.after * 1000, 0, vim.schedule_wrap(function()
                if timer:is_active() then timer:stop() end
                require("zone.styles."..(opts.style or "treadmill")).start()
            end))

            vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                group = grp,
                callback = function()
                    if timer:is_active() then timer:stop() end
                    if not timer:is_closing() then timer:close() end
                end,
                once=true
            })
        end,
    })
end

return zone
