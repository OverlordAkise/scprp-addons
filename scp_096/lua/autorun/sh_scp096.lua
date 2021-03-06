--Luctus SCP096 System
--Made by OverlordAkise

--ADD THE FOLLOWING TO YOUR WORKSHOP COLLECTION:
--https://steamcommunity.com/sharedfiles/filedetails/?id=1315125663
-- ^ Playermodel
--https://steamcommunity.com/sharedfiles/filedetails/?id=2488399203
-- ^ Hand model

if SERVER then
  
  resource.AddWorkshop("1315125663") -- SCP096 Playermodel
  resource.AddWorkshop("2488399203") -- SCP096 Hand model
  
  util.AddNetworkString("luctus_scp096_update")
  
  scp096_ply = nil
  scp096_hunted_players = {}
  scp096_hunting = false
  
  hook.Add("OnPlayerChangedTeam","luctus_scp096", function(ply, beforeNum, afterNum)
    if RPExtraTeams[afterNum] and RPExtraTeams[afterNum].name == "SCP 096" then
      scp096_ply = ply
    end
    if RPExtraTeams[beforeNum] and RPExtraTeams[beforeNum].name == "SCP 096" then
      scp096_ply:StopSound( "096/scream.wav" )
      scp096_ply:StopSound( "096/crying1.wav" )
      scp096_ply = nil
      scp096_hunted_players = {}
    end
  end)
  hook.Add("PlayerDisconnected", "luctus_scp096_plynil", function(ply)
    if ply == scp096_ply then
      scp096_ply = nil
      scp096_hunted_players = {}
    end
  end)
  
  hook.Add("PostPlayerDeath","luctus_scp096_plynil", function(ply)
    luctus_update_hunted(ply,false)
    if ply == scp096_ply then
      scp096_ply:StopSound( "096/scream.wav" )
      scp096_ply:StopSound( "096/crying1.wav" )
      scp096_hunted_players = {}
      net.Start("luctus_scp096_update")
        net.WriteTable({})
      net.Send(scp096_ply)
    end
  end)
  
  
  
  function luctus_update_hunted(ply,newHunted)
    local new = false
    if newHunted and not table.HasValue(scp096_hunted_players,ply) then
      table.insert(scp096_hunted_players,ply)
      new = true
    end
    if not newHunted and table.HasValue(scp096_hunted_players,ply) then
      table.RemoveByValue(scp096_hunted_players,ply)
      new = true
    end
    
    if #scp096_hunted_players > 0 then
      scp096_hunting = true
      if new then
        scp096_ply:SetRunSpeed(600)
        scp096_ply:SetWalkSpeed(600)
        scp096_ply:EmitSound( "096/scream.wav" )
        scp096_ply:GetActiveWeapon():SetHoldType( "fist" )
      end
    else
      scp096_hunting = false
      if new then
        scp096_ply:SetRunSpeed(240)
        scp096_ply:SetWalkSpeed(160)
        scp096_ply:GetActiveWeapon():SetHoldType( "normal" )
      end
    end
    if new then
      net.Start("luctus_scp096_update")
        net.WriteTable(scp096_hunted_players)
      net.Send(scp096_ply)
    end
  end
end


print("[SCP096] SH Loaded!")
