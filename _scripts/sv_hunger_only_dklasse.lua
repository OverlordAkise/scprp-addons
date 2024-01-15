--Luctus Hunger-Only-For-DKlasse-Fix
--Made by OverlordAkise

--Jobs who count as a cook
local cookjobs = {
    ["Koch"] = true,
    ["Cook"] = true,
}
--Jobs who count as D-Class
local dclassjobs = {
    ["D-Klasse"] = true,
    ["Cook"] = true,
}

--Hungerspeed config is at addons/darkrpmodification/lua/darkrp_config/settings.lua at the bottom
--This function makes every job not called "D-Klasse" not being hungry
--Also, you only have hunger if a job called "Cook" is on the server and a player is playing it

hook.Add("PlayerInitialSpawn", "luctus_fix_hunger_dklasse_only", function(ply)
    if not timer.Exists("HMThink") then return end
    timer.Remove("HMThink")
    --https://wiki.facepunch.com/gmod/timer.Remove
    timer.Simple(0.1, function()
        timer.Create("HMThink", 10, 0, function()
            local cookOnline = nil
            for k,ply in ipairs(player.GetAll()) do
                if cookjobs[team.GetName(ply:Team())] then
                    cookOnline = true
                    break
                end
            end
            if not cookOnline then return end 

            for _,ply in ipairs(player.GetHumans()) do 
                if not ply:Alive() then continue end 
                if not dclassjobs[team.GetName(ply:Team())] then continue end 
                ply:hungerUpdate() 
            end 
        end)
    end)
    hook.Remove("PlayerInitialSpawn", "luctus_fix_hunger_dklasse_only")
    print("[luctus_hunger] Hunger fix loaded")
end)
