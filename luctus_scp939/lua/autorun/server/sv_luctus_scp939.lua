--Luctus SCP939
--Made by OverlordAkise

util.AddNetworkString("luctus_scp939_shooting")

resource.AddWorkshop("1109840518") -- SCP939 model

luctus_scp939ply = luctus_scp939ply or nil
hook.Add("OnPlayerChangedTeam", "luctus_scp939_tracking", function(ply, beforeNum, afterNum)
    --switch to scp939
    if string.EndsWith(RPExtraTeams[afterNum].name,"939") then
        luctus_scp939ply = ply
        timer.Create("luctus_scp939_proximity",1,0,LuctusSCP939ProximityChecker)
        hook.Add("EntityFireBullets","luctus_scp939_visibility",LuctusSCP939ShootNetworking)
    end
    --switch from scp939
    if string.EndsWith(RPExtraTeams[beforeNum].name,"939") then
        luctus_scp939ply = nil
        timer.Remove("luctus_scp939_proximity")
        hook.Remove("EntityFireBullets","luctus_scp939_visibility")
    end
end)

hook.Add("PlayerDisconnected","luctus_scp939_tracking",function(ply)
    if ply == luctus_scp939ply then
        luctus_scp939ply = nil
        timer.Remove("luctus_scp939_proximity")
        hook.Remove("EntityFireBullets","luctus_scp939_visibility")
    end
    
end)

luctus_scp939closeplys = {}
luctus_scp939cooldowns = {}
function LuctusSCP939ProximityChecker()
    luctus_scp939closeplys = {}
    if not IsValid(luctus_scp939ply) then return end
    local spos = luctus_scp939ply:GetPos()
    for k,ply in ipairs(player.GetAll()) do
        if spos:Distance(ply:GetPos()) < 2048 then
            luctus_scp939closeplys[ply] = true
            luctus_scp939cooldowns[ply] = 0
        end
    end
end

function LuctusSCP939ShootNetworking(ent,data)
    if not luctus_scp939closeplys[ent] then return end
    if luctus_scp939cooldowns[ent] > CurTime() then return end
    if not luctus_scp939ply:IsLineOfSightClear(ent) then return end
    luctus_scp939cooldowns[ent] = CurTime()+0.5
    net.Start("luctus_scp939_shooting")
        net.WriteEntity(ent)
    net.Send(luctus_scp939ply)
end


print("[scp939] sv loaded")
