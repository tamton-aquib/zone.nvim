-- TODO: get place on correct (row,col), read about `ephemeral`
local H = {}
local ns = vim.api.nvim_create_namespace("zone")
local is_running, timer, id
local zone_win, zone_buf
local uv = vim.loop
local w = 6
local helper_opts = {
    tick_time = 100,
    win_opts = {
		relative="win", width=vim.o.columns-w, height=vim.o.lines - 2,
		border="none", row=0, col=w, style='minimal'
    }
}

H.create_and_initiate = function(on_init, opts)
    helper_opts = vim.tbl_deep_extend("force", helper_opts, opts or {})

    -- TODO: pass bufnr into on_init maybe
    if type(on_init) == "function" then on_init() end

	zone_buf = vim.api.nvim_create_buf(false, true)
	zone_win = vim.api.nvim_open_win(zone_buf, false, helper_opts.win_opts)
    is_running = true

    vim.api.nvim_win_set_option(zone_win, 'winhl', 'Normal:Normal')
    -- TODO: add this keymap stuff later without breaking anything
    -- vim.keymap.set('n', '<Esc>', function() Internal.zone_close() end, {noremap=true, buffer=zone_buf})

    vim.api.nvim_create_autocmd('CursorMoved', { callback=H.zone_close, once=true })

    return zone_buf
end

H.set_buf_view = function(og_buf)
    local start_line = vim.fn.line("w0")
    local end_line = start_line + vim.o.lines

    local local_content = vim.api.nvim_buf_get_lines(og_buf, start_line, end_line, false)

    -- TODO: Feels like we can optimize stuff here
    local matrix = {}
    for i=0, #local_content-1 do
        local newt = {}
        local line = local_content[i+1]

        for j=0, line:len() do
            local nice = vim.treesitter.get_captures_at_pos(og_buf, i+start_line, j-1)
            nice = vim.tbl_filter(function(h) return h.capture ~= "spell" end, nice)
            local hl = #nice > 0 and nice[#nice].capture or 'none'
            table.insert(newt, {line:sub(j, j+(helper_opts.headache and 1 or 0)), "@"..hl})
        end

        table.insert(matrix, newt)
    end

    id = vim.api.nvim_buf_set_extmark(zone_buf, ns, 0, 0, { virt_lines=matrix })

    return matrix, ns, id
end

H.on_each_tick = function(callback)
	timer = uv.new_timer()
	timer:start(1000, helper_opts.tick_time or 100, vim.schedule_wrap(
        function()
            if not vim.api.nvim_buf_is_valid(zone_buf) then
                vim.pretty_print("Buf does not exist")
                timer:stop()
                return
            end

            callback()
        end
    ))

    return timer
end

H.zone_close = function()
	if is_running then
        vim.schedule(function()
            if id then
                vim.api.nvim_buf_del_extmark(zone_buf, ns, id)
            end

            pcall(vim.api.nvim_win_close, zone_win, true)
            pcall(vim.api.nvim_buf_delete, zone_buf, {force=true})

            if timer:is_active() then timer:stop() end
            if not timer:is_closing() then timer:close() end

            if type(H.on_exit) == "function" then H.on_exit() end
            is_running = false
        end)
	end
end

return H
