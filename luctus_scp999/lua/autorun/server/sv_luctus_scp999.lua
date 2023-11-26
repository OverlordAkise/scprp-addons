--Luctus SCP999
--Made by OverlordAkise

resource.AddWorkshop("1276030302") -- SCP999 orange blob model
resource.AddWorkshop("2310758051") -- Sounds and SWEP stuff

util.AddNetworkString("luctus_scp999_hearts")

hook.Add("OnPlayerChangedTeam","luctus_scp999_view", function(ply, beforeNum, afterNum)
    --to scp999
    if string.EndsWith(RPExtraTeams[afterNum].name,"999") then
        ply:SetViewOffset(Vector(0,0,15))
        ply:SetViewOffsetDucked(Vector(0,0,15))
    end
    --away from 999
    if string.EndsWith(RPExtraTeams[beforeNum].name,"999") then
        ply:SetViewOffset(Vector(0,0,64))
        ply:SetViewOffsetDucked(Vector(0,0,28))
    end
end)

luctus_scp999damagecooldown = 0
hook.Add("EntityTakeDamage", "luctus_scp999_damagesound", function(target, dmginfo)
    if not target:IsPlayer() or not target:HasWeapon("weapon_luctus_scp999") then return end
    if luctus_scp999damagecooldown <= CurTime() then
        luctus_scp999damagecooldown = CurTime() + LUCTUS_SCP999_DAMAGESOUND_DELAY
        target:EmitSound("scp999/scp999_damage.mp3")
    end
end)

print("[scp999] sv loaded")
