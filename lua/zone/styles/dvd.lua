local dvd = {}
local mod = require("zone.helper")
local win, buf
local local_opts
-- TODO: change these to config options
local lines = vim.split([[
⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⡀
⠀⢠⣿⣿⡿⠀⠀⠈⢹⣿⣿⡿⣿⣿⣇⠀⣠⣿⣿⠟⣽⣿⣿⠇⠀⠀⢹⣿⣿⣿
⠀⢸⣿⣿⡇⠀⢀⣠⣾⣿⡿⠃⢹⣿⣿⣶⣿⡿⠋⢰⣿⣿⡿⠀⠀⣠⣼⣿⣿⠏
⠀⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⠀⠀⢿⣿⣿⠏⠀⠀⢸⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣸⣟⣁⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣠⣴⣶⣾⣿⣿⣻⡟⣻⣿⢻⣿⡟⣛⢻⣿⡟⣛⣿⡿⣛⣛⢻⣿⣿⣶⣦⣄⡀⠀
⠉⠛⠻⠿⠿⠿⠷⣼⣿⣿⣼⣿⣧⣭⣼⣿⣧⣭⣿⣿⣬⡭⠾⠿⠿⠿⠛⠉⠀
]], '\n')
local text_w = vim.api.nvim_strwidth(lines[1])
local text_h = #lines-1
local direction = {"r", "d"}
local hl = 'TSType'

local check_touch_side = function(row, col)
    local old = direction
    local first, second = unpack(direction)
    if (row + text_h) >= vim.o.lines-2 then direction = {first, "u"} end
    if (col + text_w) >= vim.o.columns-2 then direction = {"l", second} end
    if col <= 1 then direction = {"r", second} end
    if row <= 1 then direction = {first, "d"} end
    if not vim.deep_equal(old, direction) then
        local stuff = {'TSFuncBuiltin', 'TSKeyword', 'TSType', 'TSFunction'}
        hl = stuff[math.random(4)]
    end
end
local get_rand = function()
    math.randomseed(os.time())
    local r = math.random(1, vim.o.lines-text_h-1)
    local c = math.random(1, vim.o.columns-text_w-1)
    return r, c
end

function dvd.start(opts)
    local_opts = opts or {tick_time=100}
    local r, c = get_rand()
    mod.create_and_initiate(function()
        buf = vim.api.nvim_create_buf(false, true)
        win = vim.api.nvim_open_win(buf, false, {
            relative="editor", style='minimal', height=text_h, width=text_w,
            row=r, col=c
        })
        vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal')
        vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)
    end, local_opts)

    mod.on_exit = function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, {force=true})
    end

    mod.on_each_tick(function()
        if not vim.api.nvim_win_is_valid(win) then return end
        local config = vim.api.nvim_win_get_config(win)
        local row, col = config["row"][false], config["col"][false]

        check_touch_side(row, col)

        if vim.deep_equal(direction, {"r", "d"}) then
            config["row"] = row + 1
            config["col"] = col + 1
        elseif vim.deep_equal(direction, {"r", "u"}) then
            config["row"] = row - 1
            config["col"] = col + 1
        elseif vim.deep_equal(direction, {"l", "d"}) then
            config["row"] = row + 1
            config["col"] = col - 1
        elseif vim.deep_equal(direction, {"l", "u"}) then
            config["row"] = row - 1
            config["col"] = col - 1
        else
            vim.pretty_print("[zone.nvim] Invalid direction: ", direction)
        end

        vim.api.nvim_win_set_option(win, 'winhl', 'Normal:'..hl)
        vim.api.nvim_win_set_config(win, config)
    end)
end

return dvd
