local U = require(script.Parent.Parent.utils)
local C = require(script.Parent.Parent.constants)
local M, running = {}, false

local function getRemote()
  local c = {{"Remote","ShopRE"},{"Remote","EggRE"}}
  for _,p in ipairs(c) do local r=U.GetRemote(p) if r then return r end end
end

local function pickEgg(opts)
  return opts.eggName or C.EGG_NAMES[1]
end

function M.start(opts)
  if running then return end
  running = true
  local re = getRemote()
  U.threadLoop(function() return running end, opts.buyCooldown or C.BUY_COOLDOWN, function()
    if re then re:FireServer("PurchaseEgg", pickEgg(opts)) end
  end)
end

function M.stop() running = false end
return M
