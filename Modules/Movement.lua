--[[
    PURPLE HUB V-PRO: MODULE - MOVEMENT
    Includes: Velocity Fly, NoClip, Speed Bypass
]]

local Movement = {}

function Movement:Init(UI, Core)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local MovementTab = UI:CreateTab("Movement")

    -- State Değişkenleri
    local flyEnabled = false
    local noclipEnabled = false
    local flySpeed = 50

    -- 1. NOCLIP (Duvarların İçinden Geçme)
    MovementTab:AddToggle("NoClip", function(state)
        noclipEnabled = state
    end)

    RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    -- 2. VELOCITY FLY (Süzülerek Uçma)
    MovementTab:AddToggle("Fly (Velocity)", function(state)
        flyEnabled = state
        
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = char.HumanoidRootPart

        if flyEnabled then
            -- Havada Asılı Kalma Gövdesi (BodyVelocity)
            local bv = Instance.new("BodyVelocity")
            bv.Name = "PurpleFlyBV"
            bv.Parent = hrp
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0, 0, 0)

            local bg = Instance.new("BodyGyro")
            bg.Name = "PurpleFlyBG"
            bg.Parent = hrp
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.CFrame = hrp.CFrame

            -- Uçuş Döngüsü
            task.spawn(function()
                while flyEnabled and hrp:FindFirstChild("PurpleFlyBV") do
                    local moveDir = char:FindFirstChildOfClass("Humanoid").MoveDirection
                    
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = Camera.CFrame.LookVector * (moveDir.Magnitude * flySpeed)
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    bg.CFrame = Camera.CFrame
                    RunService.RenderStepped:Wait()
                end

                -- Kapandığında objeleri temizle
                if hrp:FindFirstChild("PurpleFlyBV") then hrp.PurpleFlyBV:Destroy() end
                if hrp:FindFirstChild("PurpleFlyBG") then hrp.PurpleFlyBG:Destroy() end
            end)
        else
            if hrp:FindFirstChild("PurpleFlyBV") then hrp.PurpleFlyBV:Destroy() end
            if hrp:FindFirstChild("PurpleFlyBG") then hrp.PurpleFlyBG:Destroy() end
        end
    end)

    -- 3. SPEED BYPASS (Hızlı Yürüme)
    MovementTab:AddToggle("Speed Boost", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = state and 32 or 16
        end
    end)

    print("[PurpleHub] Movement Module Loaded with Fly & NoClip!")
end

return Movement
