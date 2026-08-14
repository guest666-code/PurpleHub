--[[
    PURPLE HUB V-PRO: MODULE - COMBAT
    Includes: Auto-Block, Hitbox Extender, Aimbot, Auto-Attack
]]

local Combat = {}

function Combat:Init(UI, Core)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local CombatTab = UI:CreateTab("Combat")

    -- State Değişkenleri
    local autoBlock = false
    local autoAttack = false
    local aimbotEnabled = false
    local hitboxExtender = false

    -- En Yakın Düşmanı Bulma Fonksiyonu
    local function GetClosestPlayer()
        local closest = nil
        local maxDistance = 100 -- Algılama mesafesi

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                if hum and hum.Health > 0 then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist < maxDistance then
                        maxDistance = dist
                        closest = player
                    end
                end
            end
        end
        return closest
    end

    -- 1. AIMBOT (Kamera Kilitleme)
    CombatTab:AddToggle("Camera Aimbot", function(state)
        aimbotEnabled = state
    end)

    RunService.RenderStepped:Connect(function()
        if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)

    -- 2. AUTO-ATTACK (Otomatik Vuruş / M1 Loop)
    CombatTab:AddToggle("Auto-Attack (M1)", function(state)
        autoAttack = state
        
        task.spawn(function()
            while autoAttack do
                local target = GetClosestPlayer()
                if target and LocalPlayer.Character then
                    -- TSB'de vuruş tetiklemek için sanal sol tık/attack eventi
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), Camera.CFrame)
                    task.wait(0.05)
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), Camera.CFrame)
                end
                task.wait(0.15) -- Saldırı hızı ayarı
            end
        end)
    end)

    -- 3. AUTO-BLOCK
    CombatTab:AddToggle("Auto-Block (Pro)", function(state)
        autoBlock = state
        -- Auto-block mantığı
    end)

    -- 4. HITBOX EXTENDER
    CombatTab:AddToggle("Hitbox Extender", function(state)
        hitboxExtender = state
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if hitboxExtender then
                    player.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                    player.Character.HumanoidRootPart.Transparency = 0.7
                    player.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really purple")
                else
                    player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    player.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end)

    -- Sürpriz modülün için ayrılan alan
    CombatTab:AddToggle("Secret Feature", function(state)
        -- Sürpriz kodun buraya bağlanacak
    end)

    print("[PurpleHub] Combat Module Loaded with Aimbot & AutoAttack!")
end

return Combat
