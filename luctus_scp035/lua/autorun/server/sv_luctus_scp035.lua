--Luctus SCP035 System
--Made by OverlordAkise

resource.AddWorkshop("268195264")

hook.Add("OnPlayerChangedTeam","luctus_scp035_dropmask", function(ply, beforeNum, afterNum)
    if ply:GetNWBool("isSCP035",false) then
        ply:SetNWBool("isSCP035",false)
        local maskent = ents.Create("luctus_scp035")
        maskent:SetPos(ply:GetPos()+Vector(0,0,20))
        maskent:Spawn()
        maskent:Activate()
        if ply.loldJobName then
            ply:setDarkRPVar("job",ply.loldJobName)
            ply.loldJobName = nil
        end
    end
end)

hook.Add("PostPlayerDeath","luctus_scp035_dropmask",function(ply)
    if ply:GetNWBool("isSCP035",false) then
        ply:SetNWBool("isSCP035",false)
        local maskent = ents.Create("luctus_scp035")
        maskent:SetPos(ply:GetPos()+Vector(0,0,20))
        maskent:Spawn()
        maskent:Activate()
        if ply.loldJobName then
            ply:setDarkRPVar("job",ply.loldJobName)
            ply.loldJobName = nil
        end
    end
end)

print("[scp035] sv loaded")
