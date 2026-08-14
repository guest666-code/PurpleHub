local Admin = {}

function Admin:Init(UI, Core)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local AdminTab = UI:CreateTab("Admin")

    -- Server Teleport / Rejoin
    AdminTab:AddToggle("Rejoin Server", function(state)
        if state then
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end
    end)

    -- Server Hop (Farklı Sunucuya Geçiş)
    AdminTab:AddToggle("Server Hop", function(state)
        if state then
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=100"))
            
            for _, s in pairs(servers.data) do
                if s.playing ~= s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end)

    -- Infinite Yield Yükleyici (Tüm Admin Komutları İçin)
    AdminTab:AddToggle("Load Infinite Yield", function(state)
        if state then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    end)
end

return Admin

