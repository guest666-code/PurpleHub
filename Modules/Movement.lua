local Movement = {}
function Movement:Init(UI, Core)
    local Tab = UI:CreateTab("Movement")
    
    Tab:AddToggle("Speed Bypass", function(s)
        -- TSB Anti-Cheat'ine takılmayan WalkSpeed
    end)
end
return Movement

