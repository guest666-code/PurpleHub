--[[ GÜNCELLEDİĞİMİZ DEBUG MODLU INIT.LUA ]]
local PurpleHub = { Modules = {} }
local BASE_URL = "https://raw.githubusercontent.com/guest666-code/PurpleHub/refs/heads/main/"

function PurpleHub:Start()
    print("[PurpleHub] UI Yukleniyor...")
    local success, UILib = pcall(function() return loadstring(game:HttpGet(BASE_URL .. "UI/Library.lua"))() end)
    
    if not success then warn("[PurpleHub] UI Library Yuklenemedi: " .. tostring(UILib)) return end
    
    self.UI = UILib:CreateWindow("🟣 PURPLE HUB V-PRO | TSB")

    local function Load(name)
        print("[PurpleHub] Yukleniyor: " .. name)
        local success, mod = pcall(function() return loadstring(game:HttpGet(BASE_URL .. "Modules/" .. name .. ".lua"))() end)
        
        if success and mod then
            self.Modules[name] = mod
            mod:Init(self.UI, self)
            print("[PurpleHub] " .. name .. " Basariyla Baglandi.")
        else
            warn("[PurpleHub] HATA - " .. name .. " yuklenemedi: " .. tostring(mod))
        end
    end

    Load("Combat")
    Load("Visuals")
    Load("Movement")
    print("[PurpleHub] Islem tamamlandi.")
end

PurpleHub:Start()
