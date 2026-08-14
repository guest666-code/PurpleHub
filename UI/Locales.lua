--[[
    PURPLE HUB V-PRO: LOCALIZATION SYSTEM (i18n)
    Supported Languages: TR (Türkçe), EN (English), RU (Русский), ES (Español)
]]

local Locales = {
    CurrentLanguage = "TR", -- Varsayılan dil
    
    Translations = {
        TR = {
            HUB_TITLE = "PURPLE HUB V-PRO | TSB",
            TAB_COMBAT = "Savaş",
            TAB_MOVEMENT = "Hareket",
            TAB_VISUALS = "Görsel",
            TAB_ADMIN = "Admin",
            
            -- Combat
            AIMBOT = "Kamera Aimbot",
            AUTO_ATTACK = "Otomatik Saldırı (M1)",
            AUTO_BLOCK = "Otomatik Blok (Pro)",
            HITBOX = "Hitbox Genişletici",
            
            -- Movement
            FLY = "Uçma (Velocity)",
            NOCLIP = "Duvarlardan Geçme",
            SPEED = "Hız Arttırma",
            
            -- Visuals
            BOX_ESP = "Kutu ESP",
            NAMETAG_ESP = "İsim Etiketleri",
            ULT_TRACKER = "Ulti Takipçisi",
            
            -- Status
            ULT_ACTIVE = "🔥 ULTİ AKTİF!",
            NOTIFY_ADMIN = "Yetkili modu değiştirildi."
        },
        EN = {
            HUB_TITLE = "PURPLE HUB V-PRO | TSB",
            TAB_COMBAT = "Combat",
            TAB_MOVEMENT = "Movement",
            TAB_VISUALS = "Visuals",
            TAB_ADMIN = "Admin",
            
            -- Combat
            AIMBOT = "Camera Aimbot",
            AUTO_ATTACK = "Auto-Attack (M1)",
            AUTO_BLOCK = "Auto-Block (Pro)",
            HITBOX = "Hitbox Extender",
            
            -- Movement
            FLY = "Velocity Fly",
            NOCLIP = "NoClip Mode",
            SPEED = "Speed Boost",
            
            -- Visuals
            BOX_ESP = "Box ESP",
            NAMETAG_ESP = "Nametags",
            ULT_TRACKER = "Ultimate Tracker",
            
            -- Status
            ULT_ACTIVE = "🔥 ULT ACTIVE!",
            NOTIFY_ADMIN = "Admin mode toggled."
        },
        RU = {
            HUB_TITLE = "PURPLE HUB V-PRO | TSB",
            TAB_COMBAT = "Бой",
            TAB_MOVEMENT = "Движение",
            TAB_VISUALS = "Визуалы",
            TAB_ADMIN = "Админ",
            
            -- Combat
            AIMBOT = "Аимбот Камеры",
            AUTO_ATTACK = "Авто-Атака (M1)",
            AUTO_BLOCK = "Авто-Блок (Pro)",
            HITBOX = "Увеличить Хитбокс",
            
            -- Movement
            FLY = "Poлёт (Velocity)",
            NOCLIP = "Сквозь Стены",
            SPEED = "Ускорение",
            
            -- Visuals
            BOX_ESP = "ESP Боксы",
            NAMETAG_ESP = "Никнеймы",
            ULT_TRACKER = "Трекер Ультимейта",
            
            -- Status
            ULT_ACTIVE = "🔥 УЛЬТА АКТИВНА!",
            NOTIFY_ADMIN = "Админ режим изменен."
        },
        ES = {
            HUB_TITLE = "PURPLE HUB V-PRO | TSB",
            TAB_COMBAT = "Combate",
            TAB_MOVEMENT = "Movimiento",
            TAB_VISUALS = "Visuales",
            TAB_ADMIN = "Admin",
            
            -- Combat
            AIMBOT = "Aimbot de Cámara",
            AUTO_ATTACK = "Ataque Automático (M1)",
            AUTO_BLOCK = "Bloqueo Auto (Pro)",
            HITBOX = "Extensor de Hitbox",
            
            -- Movement
            FLY = "Vuelo (Velocity)",
            NOCLIP = "Atravesar Paredes",
            SPEED = "Aumento de Velocidad",
            
            -- Visuals
            BOX_ESP = "ESP Cajas",
            NAMETAG_ESP = "Nombres",
            ULT_TRACKER = "Rastreador de Ulti",
            
            -- Status
            ULT_ACTIVE = "🔥 ¡ULTI ACTIVA!",
            NOTIFY_ADMIN = "Modo admin cambiado."
        }
    }
}

-- Metin Çekme Fonksiyonu
function Locales:Get(key)
    local lang = self.Translations[self.CurrentLanguage] or self.Translations["EN"]
    return lang[key] or key
end

-- Dil Değiştirme Fonksiyonu
function Locales:SetLanguage(langCode)
    if self.Translations[langCode] then
        self.CurrentLanguage = langCode
        print("[PurpleHub] Dil değiştirildi: " .. langCode)
    end
end

return Locales

