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
        luctus_createBlinkTimer(ply)
    end
end)

hook.Add("InitPostEntity", "luctus_scp173", function()
    local gdsys = MedConfig and true or false
    timer.Create("luctus_scp173_can_move", 0.1, 0, function()
        if not scp173_ply or not IsValid(scp173_ply) then return end
        for k,v in pairs(player.GetAll()) do
            if v == scp173_ply then continue end
            local alive = v:Alive()
            if gdsys then
                alive = not v._IsDead
            end
            if v:GetPos():DistToSqr(scp173_ply:GetPos()) > SCP173_BLINK_RANGE or not alive then
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
                local g, i = util.TraceLine{
                    start = v:EyePos() + v:EyeAngles():Forward() * 15,
                    endpos = scp173_ply:EyePos()
                    }, util.TraceLine{
                    start = v:LocalToWorld(v:OBBCenter()),
                    endpos = scp173_ply:LocalToWorld(scp173_ply:OBBCenter()),
                    filter = v
                }

                if g.Entity == scp173_ply or i.Entity == scp173_ply then
                    scp173_canmove = false
                    scp173_ply:Freeze(true)
                    return
                end
            end
        end--for loop
        
        --scp173 can move if no player sees it (no return till now)
        scp173_ply:Freeze(false)
    end)
end)

hook.Add("PlayerInitialSpawn", "luctus_scp173", function(ply)
    ply.luctus_near_scp173 = false
    ply.luctus_blinking = false
    luctus_createBlinkTimer(ply)
end)

function luctus_createBlinkTimer(ply)
    timer.Create(ply:SteamID().."_blink", SCP173_BLINK_INTERVAL, 0, function()
        if not scp173_ply or not IsValid(scp173_ply) then return end
        if not ply.luctus_near_scp173 then return end
        ply.luctus_blinking = true
        net.Start("luctus_scp173_blink")
            net.WriteFloat(SCP173_BLINK_DURATION)
        net.Send(ply)
        timer.Simple(SCP173_BLINK_DURATION, function()
            ply.luctus_blinking = false
        end)
    end)
end
 
print("[SCP173] SV Loaded!")
