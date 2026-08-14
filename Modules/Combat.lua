local Combat = {}

function Combat:Init(UI, Core)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    local CombatTab = UI:CreateTab("Combat")

    local aimbotEnabled = false
    local autoAttack = false
    local autoBlock = false

    -- En Yakın Oyuncuyu Bulma
    local function GetClosestPlayer()
        local closest = nil
        local maxDist = 100
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        closest = p
                    end
                end
            end
        end
        return closest
    end

    -- Camera Aimbot
    CombatTab:AddToggle("Camera Aimbot", function(state) aimbotEnabled = state end)

    local aimbotConnection = RunService.RenderStepped:Connect(function()
        if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)

    -- Auto Attack (TSB Remote & Tool Trigger)
    CombatTab:AddToggle("Auto-Attack (M1)", function(state)
        autoAttack = state
        task.spawn(function()
            while autoAttack do
                local char = LocalPlayer.Character
                if char then
                    -- 1. Yöntem: Eldeki Tool Tetikleme
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then 
                        tool:Activate() 
                    end
                    
                    -- 2. Yöntem: TSB Communicate Remote'una Vuruş Sinyali Gönderme
                    local communicate = char:FindFirstChild("Communicate") or game:GetService("ReplicatedStorage"):FindFirstChild("Communicate")
                    if communicate and communicate:IsA("RemoteEvent") then
                        communicate:FireServer({Goal = "LeftClick"})
                    end
                end
                task.wait(0.12) -- Vuruş hızı dilediğin gibi ayarlanabilir
            end
        end)
    end)

    -- Hitbox Extender (Karakterlerin Hitbox'ını Devasa Yapma)
    CombatTab:AddToggle("Hitbox Extender", function(state)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = state and Vector3.new(14, 14, 14) or Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = state and 0.75 or 1
                p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really purple")
            end
        end
    end)

    -- Menü Kapanınca Temizle
    UI:OnClose(function()
        aimbotEnabled = false
        autoAttack = false
        if aimbotConnection then aimbotConnection:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end)
end

return Combat

