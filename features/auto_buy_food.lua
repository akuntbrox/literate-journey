local U = require(script.Parent.Parent.utils)
local C = require(script.Parent.Parent.constants)
local M, running = {}, false

local function getRemote()
  local c = {{"Remote","ShopRE"},{"Remote","FoodRE"}}
  for _,p in ipairs(c) do local r=U.GetRemote(p) if r then return r end end
end

local function pickFood(opts)
  return opts.foodName or C.FOOD_OPTIONS[1]
end

function M.start(opts)
  if running then return end
  running = true
  local re = getRemote()
  U.threadLoop(function() return running end, 0.5, function()
    if re then re:FireServer("PurchaseFood", pickFood(opts), 1) end
  end)
end

function M.stop() running = false end
return M
