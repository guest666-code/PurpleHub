--[[
    PURPLE HUB V-PRO: ANIMATED & SOUND-ENABLED UI LIBRARY
    Developer: rodbira_EXE / SGM
]]

local Library = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- Ses Efekti Oluşturucu
local function PlaySound(soundId, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = 0.5
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

function Library:CreateWindow(hubTitle)
    local window = { Tabs = {}, IsMinimized = false }

    -- Eski UI Varsa Temizle
    if game.CoreGui:FindFirstChild("PurpleHub_Pro") then
        game.CoreGui.PurpleHub_Pro:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PurpleHub_Pro"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.CoreGui

    -- Main Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 330, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -165, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 22)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(150, 70, 255)
    stroke.Thickness = 1.8

    -- Açılış Animasyonu (Scale-up)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 330, 0, 400),
        Position = UDim2.new(0.5, -165, 0.3, 0)
    }):Play()
    PlaySound(6895079853, 1.2) -- Açılış Sesi

    -- TopBar
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 22, 32)
    topBar.BackgroundTransparency = 0.2

    local title = Instance.new("TextLabel", topBar)
    title.Text = "  " .. hubTitle
    title.Size = UDim2.new(0.65, 0, 1, 0)
    title.TextColor3 = Color3.fromRGB(245, 245, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- KÜÇÜLTME (MINIMIZE) BUTONU
    local minBtn = Instance.new("TextButton", topBar)
    minBtn.Text = "—"
    minBtn.Size = UDim2.new(0, 26, 0, 26)
    minBtn.Position = UDim2.new(1, -62, 0.5, -13)
    minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    minBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    minBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    -- KAPATMA (CLOSE) BUTONU
    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    -- Container & Nav
    local navBar = Instance.new("Frame", mainFrame)
    navBar.Size = UDim2.new(1, -16, 0, 32)
    navBar.Position = UDim2.new(0, 8, 0, 46)
    navBar.BackgroundColor3 = Color3.fromRGB(12, 11, 16)
    Instance.new("UICorner", navBar).CornerRadius = UDim.new(0, 6)

    local navLayout = Instance.new("UIListLayout", navBar)
    navLayout.FillDirection = Enum.FillDirection.Horizontal
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -16, 1, -90)
    contentFrame.Position = UDim2.new(0, 8, 0, 84)
    contentFrame.BackgroundTransparency = 1

    -- KÜÇÜLTME BAZLI ANİMASYON LOGIC
    minBtn.MouseButton1Click:Connect(function()
        PlaySound(6042053626, 1.1) -- Tıklama sesi
        window.IsMinimized = not window.IsMinimized

        if window.IsMinimized then
            -- Küçülme Animasyonu
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 330, 0, 40)
            }):Play()
            navBar.Visible = false
            contentFrame.Visible = false
        else
            -- Büyüme Animasyonu
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 330, 0, 400)
            })
            tween:Play()
            tween.Completed:Connect(function()
                if not window.IsMinimized then
                    navBar.Visible = true
                    contentFrame.Visible = true
                end
            end)
        end
    end)

    -- GECİKMELİ & ANİMASYONLU KAPATMA LOGIC (2s)
    local isClosing = false
    closeBtn.MouseButton1Click:Connect(function()
        if isClosing then return end
        isClosing = true

        PlaySound(138089312, 1.0) -- Kapanış Efekt Sesi

        -- Küçülerek ve Saydamlaşarak Kapanma Animasyonu (1.8 saniyeye yayıldı)
        TweenService:Create(mainFrame, TweenInfo.new(1.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()

        TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
            Transparency = 1
        }):Play()

        -- Tam 2 Saniye Bekleyip Nesneyi Bellekten Sil
        task.wait(2)
        screenGui:Destroy()
    end)

    -- TAB & BUTTON SYSTEM
    function window:CreateTab(tabName)
        local tab = {}

        local tabBtn = Instance.new("TextButton", navBar)
        tabBtn.Text = tabName
        tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.TextColor3 = Color3.fromRGB(140, 140, 170)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 11

        local container = Instance.new("ScrollingFrame", contentFrame)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = (#window.Tabs == 0)
        container.ScrollBarThickness = 2
        container.CanvasSize = UDim2.new(0, 0, 0, 0)

        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)

        if #window.Tabs == 0 then
            tabBtn.TextColor3 = Color3.fromRGB(170, 90, 255)
        end

        tabBtn.MouseButton1Click:Connect(function()
            PlaySound(6042053626, 1.3)
            for _, t in pairs(window.Tabs) do
                t.Container.Visible = false
                t.Button.TextColor3 = Color3.fromRGB(140, 140, 170)
            end
            container.Visible = true
            TweenService:Create(tabBtn, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(170, 90, 255) }):Play()
        end)

        tab.Container = container
        tab.Button = tabBtn

        -- ANIMASYONLU TOGGLE BUTONU
        function tab:AddToggle(text, callback)
            local btn = Instance.new("TextButton", container)
            btn.Text = "  " .. text
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(24, 23, 34)
            btn.TextColor3 = Color3.fromRGB(220, 220, 240)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 11
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            local status = Instance.new("Frame", btn)
            status.Size = UDim2.new(0, 16, 0, 16)
            status.Position = UDim2.new(1, -24, 0.5, -8)
            status.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            Instance.new("UICorner", status).CornerRadius = UDim.new(0, 4)

            local state = false
            btn.MouseButton1Click:Connect(function()
                state = not state
                
                -- Tıklama Ses Efekti (Aktif/Pasif durumuna göre ton değiştirir)
                PlaySound(6042053626, state and 1.5 or 0.9)

                -- Buton Tıklama Yay/Bounce Animasyonu
                TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(0.97, 0, 0, 34) }):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(1, 0, 0, 36) }):Play()

                -- Renk Geçiş Animasyonu
                TweenService:Create(status, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = state and Color3.fromRGB(160, 70, 255) or Color3.fromRGB(45, 45, 60)
                }):Play()

                pcall(callback, state)
            end)
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return Library

