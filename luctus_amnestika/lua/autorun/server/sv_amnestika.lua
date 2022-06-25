--Luctus Amnestika
--Made by OverlordAkise

resource.AddWorkshop("2595071184")
util.AddNetworkString("luctus_amnestika")

function SendAmnestikaEffect(sending_ply, target_ply, amnestika_type)
    --testing:
    --target_ply = sending_ply
    if not IsValid(target_ply) or not IsValid(sending_ply) then return end
    if not target_ply:IsPlayer() then return end
    if not string.StartWith(sending_ply:GetActiveWeapon():GetClass(),"weapon_amnestika") then return end
    
    print("[amnestika] "..sending_ply:Nick().." ("..sending_ply:SteamID()..") has given amnestika to "..target_ply:Nick().." ("..target_ply:SteamID()..")")
    
    net.Start("luctus_amnestika")
        net.WriteString(amnestika_type)
    net.Send(target_ply)
end


print("amnestika loaded!")
