local zone = {}
local timer

local default_opts = {
    style = "treadmill",
    after = 10,
    tick_time = 0.1, -- todo: make it configurable inside helper.lua
    treadmill = {
        direction = "left" -- a lil buggy for `right`
    }
    -- TODO: Config options for other styles
}

zone.setup = function(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    local grp = vim.api.nvim_create_augroup('Zone', {clear=true})
    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = grp,
        pattern="*",
        callback=function()
            timer = vim.loop.new_timer()
            timer:start(opts.after * 1000, 0, vim.schedule_wrap(function()
                timer:stop()
                timer:close()
                require("zone.styles."..(opts.style or "treadmill")).start(opts[opts.style])
            end))
            vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                group=grp,
                pattern = "*",
                callback = function()
                    if timer then timer:stop() end
                end,
                once=true
            })
        end,
    })
end

return zone
