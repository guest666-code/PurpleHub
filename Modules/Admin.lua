--[[
    PURPLE HUB V-PRO: MODULE - ADMIN COMMANDS (CLIENT-SIDE SIMULATOR)
    Developer: rodbira_EXE / SGM
]]

local Admin = {}

function Admin:Init(UI, Core)
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local LocalPlayer = Players.LocalPlayer

    local AdminTab = UI:CreateTab("Admin")

    -- Ekran Bildirimi Gönderme Fonksiyonu
    local function Notify(title, text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "🟣 " .. title,
                Text = text,
                Duration = 3
            })
        end)
    end

    -- 1. ADMİN BİLDİRİM SİMÜLATÖRÜ
    AdminTab:AddToggle("Admin Mode (Visual)", function(state)
        if state then
            Notify("ADMIN MODE", "Purpleguy yetkili moduna geçiş yaptı.")
        else
            Notify("ADMIN MODE", "Yetkili modu kapatıldı.")
        end
    end)

    -- 2. SOHBET KOMUT DİNLEYİCİSİ (Chat Command Parser)
    LocalPlayer.Chatted:Connect(function(msg)
        local args = string.split(msg, " ")
        local cmd = string.lower(args[1])

        -- /speed <sayı>
        if cmd == "/speed" and args[2] then
            local speedVal = tonumber(args[2])
            if speedVal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedVal
                Notify("COMMAND", "Hız ayarlandı: " .. tostring(speedVal))
            end

        -- /jump <sayı>
        elseif cmd == "/jump" and args[2] then
            local jumpVal = tonumber(args[2])
            if jumpVal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = jumpVal
                Notify("COMMAND", "Zıplama gücü ayarlandı: " .. tostring(jumpVal))
            end

        -- /invisible (Görünmezlik - Görsel)
        elseif cmd == "/invisible" then
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        part.Transparency = 1
                    end
                end
                Notify("COMMAND", "Karakter görünmez yapıldı (Client).")
            end

        -- /visible
        elseif cmd == "/visible" then
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    end
                end
                Notify("COMMAND", "Karakter görünür yapıldı.")
            end
        end
    end)

    print("[PurpleHub] Admin Module Loaded Successfully!")
end

return Admin

