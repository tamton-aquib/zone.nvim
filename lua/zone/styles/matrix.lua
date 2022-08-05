local matrix = {}
local mod = require("zone.helper")
local fake_buf
local lines

matrix.start = function()
    fake_buf = mod.create_and_initiate(nil)

    mod.on_each_tick(function() end)
end

return matrix
