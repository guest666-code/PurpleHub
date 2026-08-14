local PurpleHub = {
    BASE_URL = "https://raw.githubusercontent.com/guest666-code/PurpleHub/refs/heads/main/"
}

function PurpleHub:Start()
    print("[PURPLE HUB] Yükleniyor...")
    
    local success, UILib = pcall(function()
        return loadstring(game:HttpGet(self.BASE_URL .. "UI/Library.lua"))()
    end)

    if not success or not UILib then
        warn("[PURPLE HUB] Library yüklenemedi: ", UILib)
        return
    end

    self.UI = UILib:CreateWindow("PURPLE HUB V-PRO | TSB")

    local modules = {"Combat", "Movement", "Visuals", "Admin"}

    for _, modName in ipairs(modules) do
        task.spawn(function()
            local modUrl = self.BASE_URL .. "Modules/" .. modName .. ".lua"
            local modSuccess, modCode = pcall(function()
                return loadstring(game:HttpGet(modUrl))()
            end)

            if modSuccess and type(modCode) == "table" and modCode.Init then
                modCode:Init(self.UI, self)
                print("[PURPLE HUB] Loaded module: " .. modName)
            else
                warn("[PURPLE HUB] Modül yüklenirken hata oluştu (" .. modName .. "):", modCode)
            end
        end)
    end
end

PurpleHub:Start()
