local U = require(script.Parent.Parent.utils)
local M, running = {}, false

local function getRemote()
  return U.GetCharacterRE()
end

function M.start(opts)
  if running then return end
  running = true
  local re = getRemote()
  U.threadLoop(function() return running end, 0.5, function()
    if re then re:FireServer("Action", "RecallAll") end
  end)
end

function M.stop() running = false end
return M
