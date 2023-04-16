--Luctus SCP966 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp966_nodraw")
resource.AddWorkshop("940572608") -- SCP966 Playermodel

scp966_ply = scp966_ply or nil

hook.Add("OnPlayerChangedTeam","luctus_scp966_view", function(ply, beforeNum, afterNum)
    if RPExtraTeams[afterNum] and string.EndsWith(RPExtraTeams[afterNum].name,"966") then
        scp966_ply = ply
        timer.Create("luctus_repair_movespeed",1,0,LuctusSCP966RepairMoveTimer)
        print("[scp966] Starting movement repair/impair timer")
        net.Start("luctus_scp966_nodraw")
        net.WriteBool(true)
        net.WriteEntity(scp966_ply)
        net.Broadcast()
    end
    if RPExtraTeams[beforeNum] and string.EndsWith(RPExtraTeams[beforeNum].name,"966") then
        scp966_ply = nil
        timer.Remove("luctus_repair_movespeed")
        LuctusSCP966RepairMovement()
        net.Start("luctus_scp966_nodraw")
        net.WriteEntity(nil)
        net.Broadcast()
    end
    ply.loldWalkSpeed = nil
    ply.loldRunSpeed = nil
end)

hook.Add("PlayerDisconnected", "luctus_scp966_plynil", function(ply)
    if ply == scp966_ply then
        scp966_ply = nil
        timer.Remove("luctus_repair_movespeed")
        LuctusSCP966RepairMovement()
        net.Start("luctus_scp966_nodraw")
        net.WriteEntity(nil)
        net.Broadcast()
    end
end)

hook.Add("PlayerSpawn", "luctus_scp966_nodraw", function(ply)
    timer.Simple(1,function()
        if scp966_ply then
            net.Start("luctus_scp966_nodraw")
            net.WriteEntity(scp966_ply)
            net.Send(ply)
        end
    end)
end)
function LuctusSCP966RepairMoveTimer()
    for k,ply in pairs(player.GetAll()) do
        --if ply:GetPos():Distance(scp966_ply:GetPos()) < 1024 then continue end
        if not ply.loldWalkSpeed then continue end
        if ply.loldWalkSpeed == ply:GetWalkSpeed() and ply.loldRunSpeed == ply:GetRunSpeed() then 
            ply.loldWalkSpeed = nil
            ply.loldRunSpeed = nil
            continue
        end
        if ply.loldWalkSpeed > ply:GetWalkSpeed() then
            ply:SetWalkSpeed(math.min(ply.loldWalkSpeed,ply:GetWalkSpeed()+ply.loldWalkSpeed/300))
            ply:SetRunSpeed(math.min(ply.loldRunSpeed,ply:GetRunSpeed()+ply.loldRunSpeed/300))
        end
    end
end

function LuctusSCP966RepairMovement(ply)
    if ply then
        if ply.loldWalkSpeed then ply:SetWalkSpeed(ply.loldWalkSpeed) end
        if ply.loldRunSpeed then ply:SetRunSpeed(ply.loldRunSpeed) end
        ply.loldWalkSpeed = nil
        ply.loldRunSpeed = nil
        return
    end
    for k,v in pairs(player.GetAll()) do
        if v.loldWalkSpeed then v:SetWalkSpeed(v.loldWalkSpeed) end
        if v.loldRunSpeed then v:SetRunSpeed(v.loldRunSpeed) end
        v.loldWalkSpeed = nil
        v.loldRunSpeed = nil
    end
end

print("[SCP966] SV Loaded!")
