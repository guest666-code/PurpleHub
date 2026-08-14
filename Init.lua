--[[
    PURPLE HUB V-PRO | THE STRONGEST BATTLEGROUNDS
    Core Manager & Module Loader
    Developer: rodbira_EXE / SGM
]]

local PurpleHub = {
    Version = "1.0.0-PRO",
    Modules = {},
    BASE_URL = "https://raw.githubusercontent.com/guest666-code/PurpleHub/refs/heads/main/"
}

function PurpleHub:Log(msg, isError)
    if isError then
        warn("🟣 [PurpleHub ERROR]: " .. tostring(msg))
    else
        print("🟣 [PurpleHub]: " .. tostring(msg))
    end
end

function PurpleHub:Start()
    self:Log("Init.lua baslatiliyor...")

    -- 1. UI Library Yükle
    local uiSuccess, UILib = pcall(function()
        return loadstring(game:HttpGet(self.BASE_URL .. "UI/Library.lua"))()
    end)

    if not uiSuccess or type(UILib) ~= "table" then
        self:Log("UI Library (Library.lua) yuklenemedi! Hata: " .. tostring(UILib), true)
        return
    end

    -- 2. Ana Pencerayi Olustur
    self.UI = UILib:CreateWindow("🟣 PURPLE HUB V-PRO | TSB")
    self:Log("UI Penceresi basariyla olusturuldu.")

    -- 3. Modulleri Yukleme Fonksiyonu
    local function LoadModule(moduleName)
        self:Log("Modul indiriliyor: " .. moduleName)
        
        local success, moduleScript = pcall(function()
            return loadstring(game:HttpGet(self.BASE_URL .. "Modules/" .. moduleName .. ".lua"))()
        end)

        if success and type(moduleScript) == "table" and moduleScript.Init then
            self.Modules[moduleName] = moduleScript
            moduleScript:Init(self.UI, self)
            self:Log(moduleName .. " modulu basariyla yuklendi ve baslatildi.")
        else
            self:Log(moduleName .. " modulu yuklenirken hata olustu! Detay: " .. tostring(moduleScript), true)
        end
    end

    -- 4. Modulleri Sirayla Agirlayalim
    LoadModule("Combat")
    LoadModule("Movement")
    LoadModule("Visuals")

    self:Log("Yukleme tamamlandi!")
end

PurpleHub:Start()
