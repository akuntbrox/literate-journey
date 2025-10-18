local U = {}

function U.GetRemote(pathArray)
  local obj = game
  for _, name in ipairs(pathArray) do
    obj = obj:FindFirstChild(name)
    if not obj then return nil end
  end
  return obj
end

function U.getLocalPlayer()
  return game.Players.LocalPlayer
end

function U.getHumanoidRootPart()
  local plr = U.getLocalPlayer()
  local char = plr and plr.Character
  return char and char:FindFirstChild("HumanoidRootPart")
end

function U.GetCharacterRE()
  local paths = {
    {"Remote", "CharacterRE"},
    {"Remotes", "CharacterRE"},
  }
  for _, p in ipairs(paths) do
    local r = U.GetRemote(p)
    if r and r:IsA("RemoteEvent") then return r end
  end
  return nil
end

function U.threadLoop(isRunning, delay, fn)
  task.spawn(function()
    while isRunning() do
      local ok, err = pcall(fn)
      if not ok then warn("[ThreadLoop]", err) end
      task.wait(delay)
    end
  end)
end

return U
