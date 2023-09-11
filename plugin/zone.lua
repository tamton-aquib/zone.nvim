vim.api.nvim_create_user_command('Zone', function(opt)
    local style = opt.args
    if style == "" then
        style = "treadmill"
    end
    require("zone.styles." .. style).start()
end, {
    complete = function()
        return { 'treadmill', 'dvd', 'vanish', 'epilepsy', 'matrix', 'customcmd' }
    end,
    nargs = "?"
}
)
