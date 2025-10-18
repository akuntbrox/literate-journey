-- main.lua
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
  Name = "BRVS Toolkit",
  LoadingTitle = "BRVS Booting",
  LoadingSubtitle = "Rayfield UI",
  ConfigurationSaving = {
    Enabled = true,
    FolderName = "BRVS_Config",
    FileName = "brvs_ui",
  },
  KeySystem = false,
})

-- Tabs
local AutomationTab = Window:CreateTab("Automation", 4483362458)
local InventoryTab  = Window:CreateTab("Inventory", 4483362458)

-- Section
AutomationTab:CreateSection("Buying & Hatching")
AutomationTab:CreateSection("World Interaction")

-- Global Options
local opts = {
  buyCooldown = 2.0,
  fishTick    = 0.30,
  collectTick = 0.25,
  placeTick   = 0.20,
}

-- Load Features
local features = {
  auto_buy      = require(script.brvs.features.auto_buy),
  auto_buy_food = require(script.brvs.features.auto_buy_food),
  auto_collect  = require(script.brvs.features.auto_collect),
  auto_fish     = require(script.brvs.features.auto_fish),
  auto_recall   = require(script.brvs.features.auto_recall),
  auto_place    = require(script.brvs.features.auto_place),
  auto_hatch    = require(script.brvs.features.auto_hatch),
}

-- Toggle helper
local function registerToggle(tab, label, flagKey, featureKey, extraOpts)
  return tab:CreateToggle({
    Name = label,
    CurrentValue = false,
    Flag = flagKey,
    Callback = function(isOn)
      local mod = features[featureKey]
      if not mod then
        Rayfield:Notify({
          Title = "Feature Missing",
          Content = ("Module '%s' tidak ditemukan."):format(featureKey),
          Duration = 6
        })
        return
      end
      if isOn then
        local merged = {}
        for k,v in pairs(opts) do merged[k] = v end
        if type(extraOpts) == "table" then
          for k,v in pairs(extraOpts) do merged[k] = v end
        end
        mod.start(merged)
      else
        mod.stop()
      end
    end,
  })
end

-- Register Toggles
local Toggles = {}
Toggles.auto_buy      = registerToggle(AutomationTab, "Auto Buy Eggs", "BRVS_AUTO_BUY", "auto_buy")
Toggles.auto_buy_food = registerToggle(AutomationTab, "Auto Buy Food", "BRVS_AUTO_BUY_FOOD", "auto_buy_food")
Toggles.auto_hatch    = registerToggle(AutomationTab, "Auto Hatch", "BRVS_AUTO_HATCH", "auto_hatch")
Toggles.auto_collect  = registerToggle(AutomationTab, "Auto Collect", "BRVS_AUTO_COLLECT", "auto_collect")
Toggles.auto_fish     = registerToggle(AutomationTab, "Auto Fish", "BRVS_AUTO_FISH", "auto_fish")
Toggles.auto_place    = registerToggle(AutomationTab, "Auto Place", "BRVS_AUTO_PLACE", "auto_place")
Toggles.auto_recall   = registerToggle(AutomationTab, "Auto Recall", "BRVS_AUTO_RECALL", "auto_recall")

-- Keybind UI toggle
AutomationTab:CreateKeybind({
  Name = "Toggle UI",
  CurrentKeybind = "RightControl",
  HoldToInteract = false,
  Flag = "BRVS_TOGGLE_UI",
  Callback = function() Rayfield:Toggle() end,
})

-- Sliders / Inputs
AutomationTab:CreateSlider({
  Name = "Buy Cooldown (s)",
  Range = { 0.10, 5.00 },
  Increment = 0.10,
  Suffix = "s",
  CurrentValue = opts.buyCooldown,
  Flag = "BRVS_BUY_COOLDOWN",
  Callback = function(v) opts.buyCooldown = v end,
})

AutomationTab:CreateInput({
  Name = "Fish Tick (s)",
  PlaceholderText = tostring(opts.fishTick),
  RemoveTextAfterFocusLost = false,
  Numeric = true,
  Finished = true,
  Flag = "BRVS_FISH_TICK",
  Callback = function(txt)
    local num = tonumber(txt)
    if num and num > 0 then opts.fishTick = num end
  end,
})

AutomationTab:CreateInput({
  Name = "Collect Tick (s)",
  PlaceholderText = tostring(opts.collectTick),
  RemoveTextAfterFocusLost = false,
  Numeric = true,
  Finished = true,
  Flag = "BRVS_COLLECT_TICK",
  Callback = function(txt)
    local num = tonumber(txt)
    if num and num > 0 then opts.collectTick = num end
  end,
})

AutomationTab:CreateInput({
  Name = "Place Tick (s)",
  PlaceholderText = tostring(opts.placeTick),
  RemoveTextAfterFocusLost = false,
  Numeric = true,
  Finished = true,
  Flag = "BRVS_PLACE_TICK",
  Callback = function(txt)
    local num = tonumber(txt)
    if num and num > 0 then opts.placeTick = num end
  end,
})

-- Inventory Paragraph
local invPara = InventoryTab:CreateParagraph({ Title = "Inventory Status", Content = "Not Bound" })

-- Notify Ready
Rayfield:Notify({
  Title = "BRVS Ready",
  Content = "Semua fitur siap — UI sudah diinisialisasi",
  Duration = 5,
})

return { Window = Window, Tabs = {Automation=AutomationTab,Inventory=InventoryTab}, Toggles=Toggles, Options=opts }
