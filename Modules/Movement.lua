local Movement = {}

function Movement:Init(UI, Core)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local MovementTab = UI:CreateTab("Movement")

    local flyEnabled = false
    local flySpeed = 50
    local speedValue = 16
    local jumpHeight = 50
    local infJump = false
    local noclipEnabled = false

    -- WalkSpeed Slider
    MovementTab:AddSlider("Walk Speed", 16, 150, 16, function(val)
        speedValue = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
        end
    end)

    -- FlySpeed Slider
    MovementTab:AddSlider("Fly Speed", 20, 200, 50, function(val)
        flySpeed = val
    end)

    -- Jump Power Slider
    MovementTab:AddSlider("Jump Power", 50, 250, 50, function(val)
        jumpHeight = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = jumpHeight
        end
    end)

    -- Infinite Jump
    MovementTab:AddToggle("Infinite Jump", function(state) infJump = state end)

    local jumpConn = UserInputService.JumpRequest:Connect(function()
        if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Velocity Fly
    MovementTab:AddToggle("Fly (Velocity)", function(state)
        flyEnabled = state
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        if flyEnabled then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "PurpleFlyBV"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

            task.spawn(function()
                while flyEnabled and hrp:FindFirstChild("PurpleFlyBV") do
                    local moveDir = char:FindFirstChildOfClass("Humanoid").MoveDirection
                    bv.Velocity = moveDir.Magnitude > 0 and (Camera.CFrame.LookVector * flySpeed) or Vector3.new(0,0,0)
                    RunService.RenderStepped:Wait()
                end
                if hrp:FindFirstChild("PurpleFlyBV") then hrp.PurpleFlyBV:Destroy() end
            end)
        else
            if hrp:FindFirstChild("PurpleFlyBV") then hrp.PurpleFlyBV:Destroy() end
        end
    end)

    -- NoClip
    MovementTab:AddToggle("NoClip", function(state) noclipEnabled = state end)

    local noclipConn = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    -- Kapanışta Sıfırlama
    UI:OnClose(function()
        flyEnabled = false
        infJump = false
        noclipEnabled = false
        if jumpConn then jumpConn:Disconnect() end
        if noclipConn then noclipConn:Disconnect() end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
        end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("PurpleFlyBV") then
            LocalPlayer.Character.HumanoidRootPart.PurpleFlyBV:Destroy()
        end
    end)
end

return Movement
