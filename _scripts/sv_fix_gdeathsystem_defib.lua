--Luctus Fix gDeath Teleport
--Made by OverlordAkise

hook.Add("InitPostEntity","luctus_fix_gdeath_defib",function()
    net.Receive("Medic.SendRagdollRequest", function(len, ply)
        local owner = net.ReadEntity()
        local pos = net.ReadVector()
        if ply:GetActiveWeapon():GetClass() == "weapon_gdefib" and ply:GetPos():Distance(owner:GetPos()) < 512 and ply:GetPos():Distance(pos) < 512 then
            ply:GetActiveWeapon():TriggerPlayer(owner, pos)
        end
    end)
end)
