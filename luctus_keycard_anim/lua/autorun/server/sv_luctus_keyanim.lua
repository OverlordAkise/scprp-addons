--Luctus Keycard Animation
--Made by OverlordAkise

util.AddNetworkString("guthscp_animation")

hook.Add("PlayerUse", "luctus_guthscp_animation", function(ply, ent)
    if not IsValid(ent) or not IsValid(ply) then return end
    if not GuthSCP or not GuthSCP.keycardAvailableClass or not GuthSCP.keycardAvailableClass[ent:GetClass()] then return end
    --Own:
    if not ply:GetActiveWeapon().GuthSCPLVL then return end
    if ply.already_animating then return end
    ply.already_animating = true
    local curwep = ply:GetActiveWeapon()
    net.Start("guthscp_animation")
        net.WriteBool(true)
    net.Send(ply)
    curwep:SetHoldType("pistol")
    timer.Simple(0.3,function()
        if not IsValid(ply) then return end
        if not curwep then return end
        net.Start("guthscp_animation")
            net.WriteBool(false)
        net.Send(ply)
        curwep:SetHoldType("slam")
        timer.Simple(0.2,function()
            if not IsValid(ply) then return end
            ply.already_animating = false
        end)
    end)
end)

print("[luctus_keycard_animation] sv loaded")
