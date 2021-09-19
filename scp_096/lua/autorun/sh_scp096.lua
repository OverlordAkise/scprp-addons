--Luctus SCP096 System
--Made by OverlordAkise

--ADD THE FOLLOWING TO YOUR WORKSHOP COLLECTION:
--https://steamcommunity.com/sharedfiles/filedetails/?id=1315125663
-- ^ Playermodel
--https://steamcommunity.com/sharedfiles/filedetails/?id=2488399203
-- ^ Hand model

hook.Add("loadCustomDarkRPItems", "luctus_scp096_drp", function()
  DarkRP.createCategory{
    name = "SCP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
  }
  TEAM_SCP096 = DarkRP.createJob("SCP 096", {
      color = Color(255, 20, 20, 255),
      model = "models/player/scp096.mdl",
      description = [[Anschauen bedeutet immediate death.]],
      weapons = {"weapon_scp096"},
      command = "scp096",
      max = 1,
      salary = GAMEMODE.Config.normalsalary * 5,
      admin = 0,
      vote = false,
      hasLicense = false,
      candemote = false,
      category = "SCP",
      PlayerSpawn = function(ply)
        ply:SetHealth(4000)
        ply:SetMaxHealth(4000)
        ply:StripWeapons()
        ply:Give("scp096_weapon")
      end,
  })
end)

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
