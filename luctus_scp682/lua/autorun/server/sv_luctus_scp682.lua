--Luctus SCP682
--Made by OverlordAkise

luctus_scp682ply = luctus_scp682ply or nil
luctus_scp682healstopuntil = luctus_scp682healstopuntil or 0
luctus_scp682immunity = luctus_scp682immunity or ""
hook.Add("OnPlayerChangedTeam", "luctus_scp682", function(ply, beforeNum, afterNum)
    --switch to scp682
    if string.EndsWith(RPExtraTeams[afterNum].name,"682") then
        luctus_scp682ply = ply
        timer.Create("luctus_scp682_scale+regen",1,0,LuctusSCP682ScaleAndRegenTimer)
        hook.Add("EntityTakeDamage","luctus_scp682",LuctusSCP682EntityTakeDamage)
    end
    --switch from scp682
    if string.EndsWith(RPExtraTeams[beforeNum].name,"682") then
        luctus_scp682ply = nil
        timer.Remove("luctus_scp682_scale+regen")
        hook.Remove("EntityTakeDamage","luctus_scp682")
    end
end)


function LuctusSCP682EntityTakeDamage(target,dmginfo)
    if target ~= luctus_scp682ply then return end
    luctus_scp682healstopuntil = CurTime()+LUCTUS_SCP682_REGEN_DAMGESTOP_DURATION
    if LUCTUS_SCP682_IMMUNITY_SYSTEM_ACTIVE then
        local attacker = dmginfo:GetAttacker()
        if not IsValid(attacker) or not attacker:IsPlayer() then return end
        local wep = attacker:GetActiveWeapon()
        if not IsValid(wep) then return end
        if luctus_scp682immunity == wep then
            return true --block
        end
        luctus_scp682immunity = wep
    end
end

local lastReadyToBeHandcuffedScream = 0
function LuctusSCP682ScaleAndRegenTimer()
    if not IsValid(luctus_scp682ply) then return end
    if LuctusSCP682DoNotRegenOrScale(luctus_scp682ply) then return end
    local hp = luctus_scp682ply:Health()
    if not LUCTUS_SCP682_REGEN_DAMAGESTOP or luctus_scp682healstopuntil < CurTime() then
        luctus_scp682ply:SetHealth(math.min(hp+LUCTUS_SCP682_REGENERATION,luctus_scp682ply:GetMaxHealth()))
    end
    local newScale = math.max((hp*LUCTUS_SCP682_MAX_MODELSCALE)/luctus_scp682ply:GetMaxHealth(),LUCTUS_SCP682_MIN_MODELSCALE)
    if newScale <= LUCTUS_SCP682_HANDCUFF_SCALE_NEEDED then
        if lastReadyToBeHandcuffedScream < CurTime() then
            lastReadyToBeHandcuffedScream = CurTime()+60
            luctus_scp682ply:EmitSound("npc/headcrab_poison/ph_hiss1.wav",100,20)
        end
    end
    luctus_scp682ply:SetModelScale(newScale,1)
end

hook.Add("CuffsCanHandcuff", "luctus_scp682",function(cuffer,target)
    if not IsValid(luctus_scp682ply) then return end
    if target == luctus_scp682ply and luctus_scp682ply:GetModelScale() > LUCTUS_SCP682_HANDCUFF_SCALE_NEEDED then return false end
end)

function LuctusSCP682DoNotRegenOrScale(ply)
    if ply.IsHandcuffed then
        return ply:IsHandcuffed()
    end
end

print("[scp682] sv loaded")
