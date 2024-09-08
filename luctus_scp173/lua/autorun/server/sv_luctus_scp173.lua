--Luctus SCP173 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp173_blink")
resource.AddWorkshop("827243834") -- SCP173 model

scp173_ply = scp173_ply or false
scp173_canmove = scp173_canmove or false
  
hook.Add("OnPlayerChangedTeam", "luctus_get_scp173", function(ply, beforeNum, afterNum)
    --switch to scp173
    if string.EndsWith(RPExtraTeams[afterNum].name,"173") then
        scp173_ply = ply
        timer.Remove(ply:SteamID().."_blink")
        ply.luctus_blinking = false
        ply.luctus_near_scp173 = false
    end
    --switch from scp173
    if string.EndsWith(RPExtraTeams[beforeNum].name,"173") then
        scp173_ply = false
        ply:Freeze(false)
        LuctusSCP173CreateBlinkTimer(ply)
    end
end)

hook.Add("InitPostEntity", "luctus_scp173", function()
    timer.Create("luctus_scp173_can_move", 0.1, 0, function()
        if not scp173_ply or not IsValid(scp173_ply) then return end
        for k,v in pairs(player.GetAll()) do
            if v == scp173_ply then continue end
            local alive = v:Alive()
            if MedConfig then
                alive = not v:GetNW2Bool("IsRagdoll", false)
            end
            if not v:IsLineOfSightClear(scp173_ply) or not alive then
                v.luctus_near_scp173 = false
                continue
            end
            v.luctus_near_scp173 = true
            if v.luctus_blinking then continue end

            --Eye Angles check
            local directionAngCos = math.cos(math.pi / 3) 
            local entVector = scp173_ply:GetPos() - v:GetShootPos() 
            local angCos = v:GetAimVector():Dot(entVector) / entVector:Length()
            if angCos >= directionAngCos then
                scp173_canmove = false
                scp173_ply:Freeze(true)
                return
            end
        end--for loop
        
        --scp173 can move if no player sees it (no return till now)
        scp173_ply:Freeze(false)
    end)
end)

hook.Add("PlayerInitialSpawn", "luctus_scp173", function(ply)
    ply.luctus_near_scp173 = false
    ply.luctus_blinking = false
    LuctusSCP173CreateBlinkTimer(ply)
end)

function LuctusSCP173CreateBlinkTimer(ply)
    timer.Create(ply:SteamID().."_blink", SCP173_BLINK_INTERVAL, 0, function()
        if not scp173_ply or not IsValid(scp173_ply) then return end
        if not ply.luctus_near_scp173 then return end
        LuctusSCP173Blink(ply)
    end)
end

function LuctusSCP173Blink(ply,duration)
    if not IsValid(ply) then return end
    if not duration then duration = SCP173_BLINK_DURATION end
    ply.luctus_blinking = true
    net.Start("luctus_scp173_blink")
        net.WriteFloat(duration)
    net.Send(ply)
    timer.Simple(duration, function()
        if not IsValid(ply) then return end
        ply.luctus_blinking = false
    end)
end

hook.Add("OnHandcuffed","luctus_scp173_handcuffon", function(attacker,victim,cuff)
    if attacker:GetActiveWeapon():GetClass() == "weapon_scp173_cuff" and victim:GetActiveWeapon():GetClass() == "weapon_handcuffed" then
        victim:SetNW2Bool("scp173cell",true)
        --victim:StripWeapon("weapon_handcuffed")
    end
end)

hook.Add("OnHandcuffBreak","luctus_scp173_handcuffbreak", function(scpPly, handcuff, maybeFriend)
    scpPly:SetNW2Bool("scp173cell",false)
end)

hook.Add("PlayerSpawn","luctus_scp173_handcuffreset", function(ply)
    ply:SetNW2Bool("scp173cell",false)
end)

--If you are frozen then SWEP:SecondaryFire wont be called, so we do it here manually
--Right mouse button is bound to force-blink here
hook.Add("PlayerButtonDown", "luctus_scp173_forceblink", function(ply, but)
    if but ~= MOUSE_RIGHT then return end
    if ply ~= scp173_ply then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or wep:GetClass() ~= "weapon_scp173" then return end
    wep:SecondaryAttack()
end)

print("[scp173] sv loaded")
