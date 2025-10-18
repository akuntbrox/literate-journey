local U = require(script.Parent.Parent.utils)
local C = require(script.Parent.Parent.constants)
local M, running = {}, false

local function getRemote()
  local c = {{"Remote","CollectRE"},{"Remotes","CollectRE"}}
  for _,p in ipairs(c) do local r=U.GetRemote(p) if r then return r end end
end

local function findTarget()
  local hrp = U.getHumanoidRootPart()
  local folder = workspace:FindFirstChild("Collectibles")
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
  local re = getRemote()
  U.threadLoop(function() return running end, opts.collectTick or C.COLLECT_TICK, function()
    local t = findTarget()
    if t and re then re:FireServer("Collect", t) end
  end)
end

function M.stop() running = false end
return M
