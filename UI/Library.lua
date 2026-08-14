--[[
    PURPLE HUB V-PRO: UI LIBRARY (FIXED ENGINE)
]]

local Library = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Library:CreateWindow(hubTitle)
    local window = { Tabs = {} }
    
    -- Gui Sıfırlama
    if game.CoreGui:FindFirstChild("PurpleHub_Pro") then
        game.CoreGui.PurpleHub_Pro:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PurpleHub_Pro"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.CoreGui

    -- Main Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 320, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(140, 60, 255)
    stroke.Thickness = 1.8

    -- TopBar
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 38)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 34)

    local title = Instance.new("TextLabel", topBar)
    title.Text = "  " .. hubTitle
    title.Size = UDim2.new(0.8, 0, 1, 0)
    title.TextColor3 = Color3.fromRGB(240, 240, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Tab Nav Bar
    local navBar = Instance.new("Frame", mainFrame)
    navBar.Size = UDim2.new(1, -16, 0, 32)
    navBar.Position = UDim2.new(0, 8, 0, 44)
    navBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    Instance.new("UICorner", navBar).CornerRadius = UDim.new(0, 6)

    local navLayout = Instance.new("UIListLayout", navBar)
    navLayout.FillDirection = Enum.FillDirection.Horizontal
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Container
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -16, 1, -86)
    contentFrame.Position = UDim2.new(0, 8, 0, 82)
    contentFrame.BackgroundTransparency = 1

    function window:CreateTab(tabName)
        local tab = {}

        local tabBtn = Instance.new("TextButton", navBar)
        tabBtn.Text = tabName
        tabBtn.Size = UDim2.new(0.33, 0, 1, 0)
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
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
            btn.TextColor3 = Color3.fromRGB(220, 220, 240)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 11
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            local status = Instance.new("Frame", btn)
            status.Size = UDim2.new(0, 14, 0, 14)
            status.Position = UDim2.new(1, -22, 0.5, -7)
            status.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            Instance.new("UICorner", status).CornerRadius = UDim.new(0, 4)

            local state = false
            btn.MouseButton1Click:Connect(function()
                state = not state
                status.BackgroundColor3 = state and Color3.fromRGB(160, 70, 255) or Color3.fromRGB(50, 50, 65)
                pcall(callback, state)
            end)
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return Library
