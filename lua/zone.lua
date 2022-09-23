local zone = {}
local timer

local default_opts = {
    style = "treadmill",
    after = 30,
    tick_time = 0.1, -- todo: make it configurable inside helper.lua
    treadmill = {
        direction = "left" -- a lil buggy for `right`
    },
    -- TODO: Config options for other styles and exclude filetypes
    -- exclude_ft = {}
}

zone.setup = function(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    local grp = vim.api.nvim_create_augroup('Zone', {clear=true})
    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        group = grp,
        callback=function()
            timer = vim.loop.new_timer()
            timer:start(opts.after * 1000, 0, vim.schedule_wrap(function()
                if timer:is_active() then timer:stop() end
                if not timer:is_closing() then timer:close() end
                require("zone.styles."..(opts.style or "treadmill")).start(opts[opts.style])
            end))
            vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                group=grp,
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
