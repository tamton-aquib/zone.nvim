-- TODO: cant quite figure out the algorithm for this style.
local matrix = {
  columns_row = {},
  columns_active = {},
}
local fake_buf, fake_win
local local_opts = require("zone.config").matrix
local chars = vim.split(
  "qwe rty uiop asda fghjkl zxc vbnmQWE  RTYU IOPASDF GHJ KL ZXCVBNM12 3456 7890!@ #$ %^&*(){}[]\\' \"; :,>/.", '')
local ns = vim.api.nvim_create_namespace("zone-matrix")

local mod = require("zone.helper")

local avoid_positions
local counter = 1
local generate_random_positions = function()
  local poss = {}
  for _ = 1, math.floor((vim.o.columns * 3) / 5) do
    local item = math.random(vim.o.columns)
    table.insert(poss, item)
  end

  return poss
end

local utf8 = require("utf8")

local function iter_over_even(t)
  local i = 0
  local n = #t
  return function()
    i = i + 2
    if i <= n then return i end
  end
end

local function gen_random_char(bool)
  local char = ' '
  if(bool == 0) then return char end
  local code = math.random(154)
  if(code < 28) then char = string.char(code + 64)
  else char = utf8.char((code - 27) % 64 + 0xFF61) end
  return char
end

local do_stuff = function(grid, id)
  for i in iter_over_even(grid[1]) do
    if (matrix.columns_row[i] == -1) then
      matrix.columns_row[i] = math.random(#grid)
      matrix.columns_active[i] = math.random(2) - 1
    end
  end

  for i in iter_over_even(grid[1]) do
    grid[matrix.columns_row[i]][i] = { gen_random_char(matrix.columns_active[i]), 'LightGreen' }

    matrix.columns_row[i] = matrix.columns_row[i] + 1

    if (matrix.columns_row[i] > #grid) then matrix.columns_row[i] = -1 end

    if (math.random(1000) == 0) then
      if (matrix.columns_active[i] == 0) then
        matrix.columns_active[i] = 1
      else
        matrix.columns_active[i] = 0
      end
    end
  end

  vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines = grid, id = id })
end

matrix.start = function()
  vim.cmd [[hi Black guifg=#000000]]
  vim.cmd [[hi Green guifg=#008000]]
  vim.cmd [[hi LightGreen guifg=#00ff00]]
  vim.cmd [[hi LighterGreen guifg=#00ff00]]
  vim.cmd [[hi LightestGreen guifg=#00ff00]]
  fake_buf, _ = mod.create_and_initiate(nil, local_opts)
  -- vim.api.nvim_win_set_option(fake_win, 'winhighlight', 'Normal:Black')

  local grid = {}

  for i = 1, vim.o.lines do
    grid[i] = {}
    for j = 1, vim.o.columns do
      grid[i][j] = { ' ', 'LightGreen' }
      matrix.columns_row[j] = -1
      matrix.columns_active[j] = 0
    end
  end

  local id = vim.api.nvim_buf_set_extmark(fake_buf, ns, 0, 0, { virt_lines = grid })

  mod.on_each_tick(function() do_stuff(grid, id) end, 10)
end

return matrix
