--Luctus Cleaner
--Made by OverlordAkise

--Time until trash re/spawns in seconds
--randomly chosen from 0.5x of that value to 2x the value
LUCTUS_CLEANER_RESPAWN_DELAY = 60

if SERVER then
    --Reward players for doing cleanup
    hook.Add("LuctusCleanDone","reward",function(ply,ent)
        ply:addMoney(30)
        DarkRP.notify(ply,0,5,"[cleaner] +30$")
    end)
end

print("[luctus_cleaner] config loaded")
