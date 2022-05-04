-- TODO: autocmds are a mess: make it clean
local Internal = {}
local is_running, timer
local zone_win, zone_buf
local uv = vim.loop
local helper_opts = {
    tick_time = 100,
    win_opts = {
		relative="win", width=vim.o.columns, height=vim.o.lines - 2,
		border="none", row=3, col=0, -- style='minimal'
    }
}

Internal.zone_close = function()
	if is_running then
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(zone_win) then
                vim.api.nvim_win_close(zone_win, true)
            end
            if vim.api.nvim_buf_is_valid(zone_buf) then
                vim.api.nvim_buf_delete(zone_buf, {force=true})
            end
            if timer:is_active() then timer:stop() end
            if not timer:is_closing() then timer:close() end
            if type(Internal.on_exit) == "function" then Internal.on_exit() end
            is_running = false
        end)
	end
end

Internal.on_each_tick = function(cb)
	timer = uv.new_timer()
	uv.timer_start(timer, 1000, helper_opts.tick_time or 100, vim.schedule_wrap(cb))

    return timer
end

--- Creates and Initiates the necessary conditions.
---@param on_init function: callback to invoke on zone startup
---@return number: the buf handler
Internal.create_and_initiate = function(on_init)
    helper_opts = vim.tbl_deep_extend("force", helper_opts, Internal.opts or {})
    if type(on_init) == "function" then on_init() end
	local pos_before = vim.api.nvim_win_get_cursor(0)
	local ft = vim.bo.ft

    local new_row = vim.fn.line('.') - vim.fn.line('w0') + 1
    local pos_after = {new_row, pos_before[2]}

	zone_buf = vim.api.nvim_create_buf(false, true)
	zone_win = vim.api.nvim_open_win(zone_buf, false, helper_opts.win_opts)
    is_running = true

    vim.schedule_wrap(function()
        vim.api.nvim_win_set_cursor(zone_win, pos_after)
    end)

	vim.api.nvim_buf_set_option(zone_buf, 'filetype', ft)
    vim.api.nvim_win_set_option(zone_win, 'winhl', 'Normal:Normal')
    -- TODO: add this keymap stuff later without breaking anything
    -- vim.keymap.set('n', '<Esc>', function() Internal.zone_close() end, {noremap=true, buffer=zone_buf})

    vim.api.nvim_create_autocmd('CursorMoved', {
        pattern="*",
        callback=function() Internal.zone_close() end,
        once=true
    })

    return zone_buf
end

return Internal
