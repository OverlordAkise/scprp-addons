--Luctus Amnestics
--Made by OverlordAkise

resource.AddWorkshop("2595071184")
util.AddNetworkString("luctus_amnestics")

function LuctusSendAmnesticsEffect(sending_ply, target_ply, amnestic_type)
    --testing: target_ply = sending_ply
    if not IsValid(target_ply) or not IsValid(sending_ply) then return end
    if not target_ply:IsPlayer() then return end
    if not string.StartWith(sending_ply:GetActiveWeapon():GetClass(),"weapon_amnestic") then return end
    
    sending_ply:PrintMessage(HUD_PRINTTALK, "You administered '"..target_ply:Nick().."' amnestic type "..amnestic_type)
    net.Start("luctus_amnestics")
        net.WriteString(amnestic_type)
    net.Send(target_ply)
    
    hook.Run("LuctusAmnestics",sending_ply,target_ply,amnestic_type)
end

print("[luctus_amnestics] sv loaded!")
