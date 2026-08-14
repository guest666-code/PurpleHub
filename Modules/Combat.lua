local Combat = {}
function Combat:Init(UI, Core)
    local Tab = UI:CreateTab("Combat")
    
    Tab:AddToggle("Auto-Block (Pro)", function(s)
        if s then
            -- TSB'de Auto-Block: Karakterin HumanoidRootPart ve Animasyonlarını dinle
            print("Auto-Block Enabled")
        end
    end)

    -- Sürprizini buraya gömeceğiz
    Tab:AddToggle("Sürpriz Mod (WIP)", function(s)
        if s then 
            -- Gizli özellik buraya
        end
    end)
end
return Combat

