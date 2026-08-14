--[[
    PURPLE HUB V-PRO: MODULE - VISUALS
    Includes: Box ESP, Nametag ESP, Ultimate Mode Tracker
    Developer: rodbira_EXE / SGM
]]

local Visuals = {}

function Visuals:Init(UI, Core)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local VisualsTab = UI:CreateTab("Visuals")

    -- State Değişkenleri
    local boxEspEnabled = false
    local nametagEspEnabled = false
    local ultTrackerEnabled = false

    -- ESP Nesnelerini Temizleme/Oluşturma Yardımcısı
    local function CreateESP(player)
        if player == LocalPlayer then return end

        local function SetupCharacter(char)
            if not char then return end
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            local head = char:WaitForChild("Head", 5)
            local hum = char:WaitForChild("Humanoid", 5)
            if not hrp or not head or not hum then return end

            -- 1. BOX ESP (Highlight / Box)
            if not char:FindFirstChild("PurpleBoxESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "PurpleBoxESP"
                highlight.Parent = char
                highlight.FillColor = Color3.fromRGB(140, 60, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.6
                highlight.OutlineTransparency = 0
                highlight.Enabled = boxEspEnabled
            end

            -- 2. NAMETAG & ULTI TRACKER ESP
            if not head:FindFirstChild("PurpleNametag") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "PurpleNametag"
                billboard.Parent = head
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Enabled = nametagEspEnabled or ultTrackerEnabled

                local nameLabel = Instance.new("TextLabel", billboard)
                nameLabel.Name = "NameLabel"
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 13
                nameLabel.Text = player.DisplayName

                local statusLabel = Instance.new("TextLabel", billboard)
                statusLabel.Name = "StatusLabel"
                statusLabel.Size = UDim2.new(1, 0, 0.5, 0)
                statusLabel.Position = UDim2.new(0, 0, 0.5, 0)
                statusLabel.BackgroundTransparency = 1
                statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                statusLabel.TextStrokeTransparency = 0
                statusLabel.Font = Enum.Font.GothamSemibold
                statusLabel.TextSize = 11
                statusLabel.Text = "HP: " .. math.floor(hum.Health)
            end
        end

        if player.Character then SetupCharacter(player.Character) end
        player.CharacterAdded:Connect(SetupCharacter)
    end

    -- Tüm Oyuncular İçin ESP Başlat
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    Players.PlayerAdded:Connect(CreateESP)

    -- ESP DÖNGÜSÜ & ULTİ TESPİTİ (RunService)
    RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                local highlight = char:FindFirstChild("PurpleBoxESP")

                -- Box ESP Güncelleme
                if highlight then
                    highlight.Enabled = boxEspEnabled
                end

                -- Nametag & Ulti Güncelleme
                if head and head:FindFirstChild("PurpleNametag") then
                    local billboard = head.PurpleNametag
                    billboard.Enabled = nametagEspEnabled or ultTrackerEnabled
                    
                    local statusLabel = billboard:FindFirstChild("StatusLabel")
                    local nameLabel = billboard:FindFirstChild("NameLabel")

                    if hum and statusLabel then
                        -- TSB Ulti Modu Kontrolü (Ultimate açıldığında karakterde aura/mode attribute veya özel efekt oluşur)
                        local isUltActive = char:FindFirstChild("Ultimate") or char:GetAttribute("Ultimate") or (hum.MaxHealth > 100)

                        if isUltActive and ultTrackerEnabled then
                            statusLabel.Text = "🔥 ULTİ AKTİF! | HP: " .. math.floor(hum.Health)
                            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                            if nameLabel then nameLabel.TextColor3 = Color3.fromRGB(255, 200, 50) end
                            if highlight then highlight.FillColor = Color3.fromRGB(255, 0, 50) end
                        else
                            statusLabel.Text = "HP: " .. math.floor(hum.Health)
                            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                            if nameLabel then nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255) end
                            if highlight then highlight.FillColor = Color3.fromRGB(140, 60, 255) end
                        end
                    end
                end
            end
        end
    end)

    -- UI TOGGLES
    VisualsTab:AddToggle("Box ESP", function(state)
        boxEspEnabled = state
    end)

    VisualsTab:AddToggle("Nametag ESP", function(state)
        nametagEspEnabled = state
    end)

    VisualsTab:AddToggle("Ulti Tracker (G Detect)", function(state)
        ultTrackerEnabled = state
    end)

    print("[PurpleHub] Visuals Module Loaded with Box, Nametag & Ult Tracker!")
end

return Visuals
