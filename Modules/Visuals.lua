local Visuals = {}

function Visuals:Init(UI, Core)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    local VisualsTab = UI:CreateTab("Visuals")

    local espEnabled = false
    local nameEspEnabled = false
    local ultTrackerEnabled = false

    local espFolder = Instance.new("Folder", game.CoreGui)
    espFolder.Name = "PurpleHub_ESP"

    -- ESP Temizleme Fonksiyonu
    local function ClearESP()
        espFolder:ClearAllChildren()
    end

    -- Box & Name ESP Oluşturucu
    local function UpdateESP()
        ClearESP()
        if not (espEnabled or nameEspEnabled or ultTrackerEnabled) then return end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local hum = p.Character:FindFirstChildOfClass("Humanoid")

                if hum and hum.Health > 0 then
                    -- Highlight / Box ESP
                    if espEnabled then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = p.Name .. "_Highlight"
                        highlight.Adornee = p.Character
                        highlight.FillColor = Color3.fromRGB(150, 60, 255)
                        highlight.FillTransparency = 0.6
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineTransparency = 0
                        highlight.Parent = espFolder
                    end

                    -- BillboardGui (İsim ve Ulti Takipçisi)
                    if nameEspEnabled or ultTrackerEnabled then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = p.Name .. "_Billboard"
                        bb.Adornee = hrp
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = espFolder

                        local txt = Instance.new("TextLabel", bb)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 11
                        txt.TextStrokeTransparency = 0

                        local displayText = ""
                        
                        if nameEspEnabled then
                            displayText = p.DisplayName .. " [" .. math.floor(hum.Health) .. " HP]"
                        end

                        -- TSB Ulti Kontrolü (Ulti/Ultimate Değeri)
                        if ultTrackerEnabled then
                            local ultValue = p:FindFirstChild("Ultimate") or p:FindFirstChild("Ult") or (p.Character and p.Character:FindFirstChild("Ultimate"))
                            if ultValue then
                                local val = ultValue.Value or 0
                                displayText = displayText .. "\n🔥 ULT: %" .. tostring(val)
                            end
                        end

                        txt.Text = displayText
                    end
                end
            end
        end
    end

    -- Toggles
    VisualsTab:AddToggle("Box ESP", function(state)
        espEnabled = state
        UpdateESP()
    end)

    VisualsTab:AddToggle("Nametag ESP", function(state)
        nameEspEnabled = state
        UpdateESP()
    end)

    VisualsTab:AddToggle("Ult Tracker", function(state)
        ultTrackerEnabled = state
        UpdateESP()
    end)

    -- Döngüsel Güncelleme
    local espLoop = RunService.RenderStepped:Connect(function()
        if espEnabled or nameEspEnabled or ultTrackerEnabled then
            UpdateESP()
        end
    end)

    -- Menü Kapandığında ESP'leri Tamamen Temizle
    UI:OnClose(function()
        espEnabled = false
        nameEspEnabled = false
        ultTrackerEnabled = false
        if espLoop then espLoop:Disconnect() end
        ClearESP()
        espFolder:Destroy()
    end)
end

return Visuals
