--Luctus SCP173 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp173_blink")
resource.AddWorkshop("827243834") -- SCP173

scp173_ply = scp173_ply or false
local scp173_canmove = scp173_canmove or false
  
hook.Add("OnPlayerChangedTeam", "luctus_get_scp173", function(ply, beforeNum, afterNum)

  --switch to scp173
  if RPExtraTeams[afterNum].name == "SCP 173" then
    scp173_ply = ply
    --PrintMessage(HUD_PRINTTALK, "Someone switched to SCP-173!")
    timer.Remove(ply:SteamID().."_blink")
    ply.luctus_blinking = false
    ply.luctus_near_scp173 = false
  end
  --switch from scp173
  if RPExtraTeams[beforeNum].name == "SCP 173" then
    scp173_ply = false
    ply:Freeze(false)
    --PrintMessage(HUD_PRINTTALK, "Someone switched from SCP-173!")
    luctus_createBlinkTimer(ply)
  end
  
  --switch to scp131 (eyes that don't blink)
  if RPExtraTeams[afterNum].name == "SCP 131-A" or RPExtraTeams[afterNum].name == "SCP 131-B" then
    timer.Remove(ply:SteamID().."_blink")
    ply.luctus_blinking = false
    ply.luctus_near_scp173 = false
  end
  --switch from scp131 (blink again)
  if RPExtraTeams[beforeNum].name == "SCP 131-A" or RPExtraTeams[beforeNum].name == "SCP 131-B" then
    luctus_createBlinkTimer(ply)
  end
end)

hook.Add("InitPostEntity", "luctus_scp173", function()
  timer.Create("luctus_scp173_can_move", 0.1, 0, function()
    if scp173_ply and IsValid(scp173_ply) then
      for k,v in pairs(player.GetAll()) do
        if v == scp173_ply then continue end
        --print("Checking "..v:Nick())
        if v:GetPos():DistToSqr(scp173_ply:GetPos()) < SCP173_BLINK_RANGE and v:Alive() then
          --print(v:Nick().." is in range and alive!")
          v.luctus_near_scp173 = true
          if v.luctus_blinking then continue end --not watching scp173
          
          local directionAngCos = math.cos(math.pi / 3) 
          local aimVector = v:GetAimVector()
          local entVector = scp173_ply:GetPos() - v:GetShootPos() 
          local angCos = aimVector:Dot(entVector) / entVector:Length()
          if (angCos >= directionAngCos) then --watching scp173 with eyes angle
            --print("Schaut in Richtung SCP-173!")
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
              --print("SCP Hit! Freezing SCP-173!")
              scp173_ply:Freeze(true)
              return
            end
          end
        else
          v.luctus_near_scp173 = false
        end
      end
      --through players with no one looking = scp173 can move
      --PrintMessage(HUD_PRINTTALK, "Unfroze SCP-173!")
      scp173_ply:Freeze(false)
    end
  end)
end)

hook.Add("PlayerInitialSpawn", "luctus_scp173", function(ply)
  ply.luctus_near_scp173 = false
  ply.luctus_blinking = false
  luctus_createBlinkTimer(ply)
end)

function luctus_createBlinkTimer(ply)
  timer.Create(ply:SteamID().."_blink", SCP173_BLINK_INTERVAL, 0, function()
    if scp173_ply and IsValid(scp173_ply) then
      if ply.luctus_near_scp173 then
        ply.luctus_blinking = true
        net.Start("luctus_scp173_blink")
          net.WriteFloat(SCP173_BLINK_DURATION)
        net.Send(ply)
        timer.Simple(SCP173_BLINK_DURATION, function()
          ply.luctus_blinking = false
        end)
      end
    end
  end)
end
 
print("[SCP173] SV Loaded!")