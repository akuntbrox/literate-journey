local U = require(script.Parent.Parent.utils)
local M, running = {}, false

local function getRemote()
  local c = {{"Remote","EggRE"}}
  for _,p in ipairs(c) do local r=U.GetRemote(p) if r then return r end end
end

local function getEggId()
  local plr = U.getLocalPlayer()
  local gui = plr:FindFirstChild("PlayerGui")
  local data = gui and gui:FindFirstChild("PlayerData")
  local eggs = data and data:FindFirstChild("Eggs")
  if not eggs then return end
  for _,v in ipairs(eggs:GetChildren()) do
    if v:IsA("IntValue") or v:IsA("StringValue") then return v.Value end
  end
end

function M.start(opts)
  if running then return end
  running = true
  local re = getRemote()
  U.threadLoop(function() return running end, 0.35, function()
    local id = getEggId()
    if id and re then re:FireServer("HatchEgg", id) end
  end)
end

function M.stop() running = false end
return M
