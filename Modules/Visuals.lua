local Visuals = {}
function Visuals:Init(UI, Core)
    local Tab = UI:CreateTab("Visuals")
    
    Tab:AddToggle("Enemy ESP", function(s)
        -- Highlight ESP mantığı (TSB'de düşmanları görme)
    end)
    
    Tab:AddToggle("Ultimate Tracker", function(s)
        -- TSB'de rakibin Ultimate barını takip etme
    end)
end
return Visuals

