--Luctus SCP457 System
--Made by OverlordAkise

resource.AddWorkshop("104607228") -- Extinguisher
hook.Add( "ExtinguisherDoExtinguish", "luctus_scp457_recontainment", function(ent)
    if ent:IsPlayer() and ent:Alive() and scp457_ply and IsValid(scp457_ply) and ent == scp457_ply then
        ent.lNoBurn = CurTime() + LUCTUS_SCP049_EXTINGUISH_DURATION
    end
    return true
end)

hook.Add("PlayerShouldTakeDamage", "luctus_scp457_fireno", function(d, e)
    if e and e:GetClass() == "entityflame" and d == scp457_ply then return false end
end)

scp457_ply = nil

hook.Add("OnPlayerChangedTeam", "luctus_scp457", function(ply, beforeNum, afterNum)
    if string.EndsWith(RPExtraTeams[afterNum].name,"457") then
        scp457_ply = ply
        ply.lNoBurn = 0
        timer.Create("luctus_scp457_burn",1,0,LuctusSCP457Burn)
    end
    
    if string.EndsWith(RPExtraTeams[beforeNum].name,"457") then
        scp457_ply = nil
        timer.Remove("luctus_scp457_burn")
    end
end)

function LuctusSCP457Burn()
    print("[DEBUG]","Running 457 timer",scp457_ply,IsValid(scp457_ply),CurTime(),scp457_ply.lNoBurn,(CurTime() < scp457_ply.lNoBurn))
    if not scp457_ply or not IsValid(scp457_ply) then return end
    if CurTime() < scp457_ply.lNoBurn then return end
    scp457_ply:Ignite(1,LUCTUS_SCP457_IGNITE_RADIUS)
    for k,v in pairs(ents.FindInSphere(scp457_ply:GetPos(),LUCTUS_SCP049_IGNITE_RADIUS)) do
        if v:IsPlayer() then
            v:Ignite(LUCTUS_SCP049_IGNITE_DURATION,50)
        end
    end
end

print("[SCP457] sv loaded")
