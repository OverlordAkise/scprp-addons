--Luctus SCP131 System
--Made by OverlordAkise


resource.AddWorkshop("935624655") -- 131-A, 131-B PlayerModels

hook.Add("OnPlayerChangedTeam","luctus_scp131_view", function(ply, beforeNum, afterNum)
    if RPExtraTeams[afterNum] and string.StartWith(RPExtraTeams[afterNum].name,"SCP 131") then
        ply:SetViewOffset(Vector(0,0,15))
        ply:SetViewOffsetDucked(Vector(0,0,15))
        ply:SetHealth(500)
        ply:SetMaxHealth(500)
        timer.Simple(0.1, function()
            ply:StripWeapons()
            ply:SetRunSpeed(240*2)
            ply:SetWalkSpeed(240)
            ply:Give("weapon_scp131")
        end)
    end
    if RPExtraTeams[beforeNum] and string.StartWith(RPExtraTeams[beforeNum].name,"SCP 131") then
        ply:SetViewOffset(Vector(0,0,64))
        ply:SetViewOffsetDucked(Vector(0,0,28))
    end
end)

hook.Add("PlayerCanPickupWeapon", "luctus_scp131_no_pickup_weps", function(ply,wep)
    if ply:Team() == TEAM_SCP131A or ply:Team() == TEAM_SCP131B then return false end
end)


print("[SCP131] SV Loaded!")
