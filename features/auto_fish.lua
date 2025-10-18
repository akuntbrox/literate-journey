local U = require(script.Parent.Parent.utils)
local C = require(script.Parent.Parent.constants)
local M, running = {}, false

local function getSpot()
  local hrp = U.getHumanoidRootPart()
  local folder = workspace:FindFirstChild("FishingSpots")
  if not hrp or not folder then return end
  local best, dist = nil, math.huge
  for _,v in ipairs(folder:GetChildren()) do
    local pos = v.Position or (v.PrimaryPart and v.PrimaryPart.Position)
    if pos then
      local d = (pos - hrp.Position).Magnitude
      if d < dist then best, dist = v, d end
    end
  end
  return best
end

function M.start(opts)
  if running then return end
  running = true
  U.threadLoop(function() return running end, opts.fishTick or C.FISH_TICK, function()
    local spot = getSpot()
    local re = U.GetCharacterRE()
    if spot and re then re:FireServer("Action", "Fish", {target = spot}) end
  end)
end

function M.stop() running = false end
return M
