--[[ PURPLE HUB V-PRO | THE STRONGEST BATTLEGROUNDS | CORE ]]
local PurpleHub = { Modules = {} }
local BASE_URL = "https://raw.githubusercontent.com/guest666-code/PurpleHub/main/"

function PurpleHub:Start()
    local UILib = loadstring(game:HttpGet(BASE_URL .. "UI/Library.lua"))()
    self.UI = UILib:CreateWindow("🟣 PURPLE HUB V-PRO | TSB")

    local function Load(name)
        local success, mod = pcall(function() return loadstring(game:HttpGet(BASE_URL .. "Modules/" .. name .. ".lua"))() end)
        if success then self.Modules[name] = mod; mod:Init(self.UI, self) else warn("Err: " .. name) end
    end

    Load("Combat")
    Load("Visuals")
    Load("Movement")
    print("Purple Hub Pro: Loaded.")
end

PurpleHub:Start()
