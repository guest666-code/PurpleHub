--[[
    PURPLE HUB V-PRO: FIXED UI LIBRARY (WITH CLEANUP TRIPPERS & FIXED AUDIO)
]]

local Library = { OnCloseEvents = {} }
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- Roblox Tarafında Garantili Çalışan Global UI Sesleri
local function PlaySound(soundType)
    local sound = Instance.new("Sound")
    if soundType == "Click" then
        sound.SoundId = "rbxassetid://12221967" -- Standart Tıklama
        sound.Pitch = 1.2
    elseif soundType == "Close" then
        sound.SoundId = "rbxassetid://12221976" -- Kapanış Sesi
        sound.Pitch = 0.8
    end
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

function Library:OnClose(fn)
    table.insert(self.OnCloseEvents, fn)
end

function Library:CreateWindow(hubTitle)
    local window = { Tabs = {}, IsMinimized = false }

    if game.CoreGui:FindFirstChild("PurpleHub_Pro") then
        game.CoreGui.PurpleHub_Pro:Destroy()
    end

    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "PurpleHub_Pro"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 340, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -170, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 22)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(150, 70, 255)
    stroke.Thickness = 1.8

    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 22, 32)

    local title = Instance.new("TextLabel", topBar)
    title.Text = "  " .. hubTitle
    title.Size = UDim2.new(0.65, 0, 1, 0)
    title.TextColor3 = Color3.fromRGB(245, 245, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- KÜÇÜLTME BUTONU (-)
    local minBtn = Instance.new("TextButton", topBar)
    minBtn.Text = "-"
    minBtn.Size = UDim2.new(0, 26, 0, 26)
    minBtn.Position = UDim2.new(1, -62, 0.5, -13)
    minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    minBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    -- KAPATMA BUTONU (X - KARE SİMGESİ DÜZELTİLDİ)
    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

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

    minBtn.MouseButton1Click:Connect(function()
        PlaySound("Click")
        window.IsMinimized = not window.IsMinimized
        TweenService:Create(mainFrame, TweenInfo.new(0.3), { Size = window.IsMinimized and UDim2.new(0, 340, 0, 40) or UDim2.new(0, 340, 0, 420) }):Play()
        navBar.Visible = not window.IsMinimized
        contentFrame.Visible = not window.IsMinimized
    end)

    -- HİLELERİ VE ARAYÜZÜ TAMAMEN KAPATAN LOGIC
    closeBtn.MouseButton1Click:Connect(function()
        PlaySound("Close")
        
        -- Tüm Modüllerdeki Hileleri Kapat (Cleanup Loop)
        for _, callback in ipairs(Library.OnCloseEvents) do
            pcall(callback)
        end

        TweenService:Create(mainFrame, TweenInfo.new(0.4), { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }):Play()
        task.wait(0.4)
        screenGui:Destroy()
    end)

    function window:CreateTab(tabName)
        local tab = {}

        local tabBtn = Instance.new("TextButton", navBar)
        tabBtn.Text = tabName
        tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.TextColor3 = Color3.fromRGB(140, 140, 170)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 10

        local container = Instance.new("ScrollingFrame", contentFrame)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = (#window.Tabs == 0)
        container.ScrollBarThickness = 2

        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 6)
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)

        if #window.Tabs == 0 then tabBtn.TextColor3 = Color3.fromRGB(170, 90, 255) end

        tabBtn.MouseButton1Click:Connect(function()
            PlaySound("Click")
            for _, t in pairs(window.Tabs) do
                t.Container.Visible = false
                t.Button.TextColor3 = Color3.fromRGB(140, 140, 170)
            end
            container.Visible = true
            tabBtn.TextColor3 = Color3.fromRGB(170, 90, 255)
        end)

        tab.Container = container
        tab.Button = tabBtn

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
                PlaySound("Click")
                status.BackgroundColor3 = state and Color3.fromRGB(160, 70, 255) or Color3.fromRGB(45, 45, 60)
                pcall(callback, state)
            end)
        end

        function tab:AddSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame", container)
            frame.Size = UDim2.new(1, 0, 0, 44)
            frame.BackgroundColor3 = Color3.fromRGB(24, 23, 34)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

            local label = Instance.new("TextLabel", frame)
            label.Text = "  " .. text .. ": " .. tostring(default)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Left

            local sliderBg = Instance.new("TextButton", frame)
            sliderBg.Text = ""
            sliderBg.Size = UDim2.new(1, -16, 0, 8)
            sliderBg.Position = UDim2.new(0, 8, 0, 26)
            sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)

            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(160, 70, 255)
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 4)

            local dragging = false
            local function Update(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                label.Text = "  " .. text .. ": " .. tostring(val)
                pcall(callback, val)
            end

            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return Library
