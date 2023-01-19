local default_opts = {
    style = "treadmill",
    after = 30,

    -- TODO: Config options for other styles and exclude filetypes
    exclude_filetypes = { 'TelescopePrompt', 'NvimTree', 'dashboard', 'lir', 'neo-tree' },

    treadmill = {
        direction = "left",  -- a lil buggy for `right`
        tick_time = 30,      -- TODO: make it configurable inside helper.lua
        headache = false
    },

    matrix = {
        tick_time = 40,
        headache = false,
    },

    epilepsy = {
        stage = "aura",
        tick_time = 100,
        headache = false
    },

    dvd = {
        text = vim.split([[
        ⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⡀
        ⠀⢠⣿⣿⡿⠀⠀⠈⢹⣿⣿⡿⣿⣿⣇⠀⣠⣿⣿⠟⣽⣿⣿⠇⠀⠀⢹⣿⣿⣿
        ⠀⢸⣿⣿⡇⠀⢀⣠⣾⣿⡿⠃⢹⣿⣿⣶⣿⡿⠋⢰⣿⣿⡿⠀⠀⣠⣼⣿⣿⠏
        ⠀⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⠀⠀⢿⣿⣿⠏⠀⠀⢸⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀
        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣸⣟⣁⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
        ⣠⣴⣶⣾⣿⣿⣻⡟⣻⣿⢻⣿⡟⣛⢻⣿⡟⣛⣿⡿⣛⣛⢻⣿⣿⣶⣦⣄⡀⠀
        ⠉⠛⠻⠿⠿⠿⠷⣼⣿⣿⣼⣿⣧⣭⣼⣿⣧⣭⣿⣿⣬⡭⠾⠿⠿⠿⠛⠉⠀
        ]], '\n')
    },

    vanish = {
        tick_time = 75,
        headache = false,
    }
}

return default_opts
