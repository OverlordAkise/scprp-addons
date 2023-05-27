--Luctus SCP035 System
--Made by OverlordAkise

resource.AddWorkshop("268195264")

hook.Add("OnPlayerChangedTeam","scp035_jobname_reset", function(ply, beforeNum, afterNum)
    if ply:GetNWBool("isSCP035",false) then
        ply:SetNWBool("isSCP035",false)
        local maskent = ents.Create("scp035_mask")
        maskent:SetPos(ply:GetPos())
        maskent:Spawn()
        maskent:Activate()
        if ply.loldJobName then
            ply:setDarkRPVar("job",ply.loldJobName)
            ply.loldJobName = nil
        end
    end
end)

hook.Add("PostPlayerDeath","scp035_spawn_mask",function(ply)
    if ply:GetNWBool("isSCP035",false) then
        ply:SetNWBool("isSCP035",false)
        local maskent = ents.Create("scp035_mask")
        maskent:SetPos(ply:GetPos())
        maskent:Spawn()
        maskent:Activate()
        if ply.loldJobName then
            ply:setDarkRPVar("job",ply.loldJobName)
            ply.loldJobName = nil
        end
    end
end)

print("[SCP035] sv loaded!")
