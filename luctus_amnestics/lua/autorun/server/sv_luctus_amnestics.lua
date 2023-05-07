--Luctus Amnestics
--Made by OverlordAkise

resource.AddWorkshop("2595071184")
util.AddNetworkString("luctus_amnestics")

LuctusLog = LuctusLog or function()end

function LuctusSendAmnesticsEffect(sending_ply, target_ply, amnestic_type)
    --testing: target_ply = sending_ply
    if not IsValid(target_ply) or not IsValid(sending_ply) then return end
    if not target_ply:IsPlayer() then return end
    if not string.StartWith(sending_ply:GetActiveWeapon():GetClass(),"weapon_amnestic") then return end

    net.Start("luctus_amnestics")
        net.WriteString(amnestic_type)
    net.Send(target_ply)
    
    LuctusLog("SCP",string.format("%s (%s) has given amnestic type %s to %s (%s)",sending_ply:Nick(),sending_ply:SteamID(),amnestic_type,target_ply:Nick(),target_ply:SteamID()))
end

print("[luctus_amnestics] sv loaded!")
