
vim.api.nvim_create_user_command('Zone', function(opt)
    require("zone.styles."..(opt.args or "treadmill")).start()
end, {
        complete=function()
            return {'treadmill', 'dvd', 'vanish', 'epilepsy', 'matrix'}
        end,
        nargs=1
    }
)
