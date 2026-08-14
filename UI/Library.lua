local Library = {}
function Library:CreateWindow(title)
    local win = { Tabs = {} }
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 300, 0, 400); main.Position = UDim2.new(0.5, -150, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); main.Active = true; main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    
    -- Title & Close
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 40); top.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("TextLabel", top).Text = title
    
    local close = Instance.new("TextButton", top)
    close.Text = "X"; close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5)
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    function win:CreateTab(name)
        local tab = { Container = Instance.new("ScrollingFrame", main) }
        tab.Container.Visible = (#win.Tabs == 0)
        -- (Buraya buton/slider ekleme fonksiyonlarını ekle)
        table.insert(win.Tabs, tab)
        return tab
    end
    return win
end
return Library

