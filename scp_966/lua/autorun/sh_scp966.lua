--Luctus SCP966 System
--Made by OverlordAkise

hook.Add("loadCustomDarkRPItems", "luctus_scp966_drp", function()
  DarkRP.createCategory{
    name = "SCP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
  }
  TEAM_SCP966 = DarkRP.createJob("SCP 966", {
      color = Color(255, 20, 20, 255),
      model = "models/vasey105/scp/scp966/scp-966.mdl",
      description = [[Unsichtbar.]],
      weapons = {"weapon_scp966"},
      command = "scp966",
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
        ply:Give("weapon_scp966")
      end,
  })
end)

if SERVER then
  util.AddNetworkString("luctus_scp966_nodraw")
  resource.AddWorkshop("940572608") -- SCP966 Playermodel
  
  scp966_ply = nil
  
  hook.Add("OnPlayerChangedTeam","luctus_scp966_view", function(ply, beforeNum, afterNum)
    if RPExtraTeams[afterNum] and RPExtraTeams[afterNum].name == "SCP 966" then
      scp966_ply = ply
      timer.Create("luctus_repair_movespeed",1,0,luctusRepairMoveSpeed)
      net.Start("luctus_scp966_nodraw")
        net.WriteBool(true)
        net.WriteEntity(scp966_ply)
      net.Broadcast()
    end
    if RPExtraTeams[beforeNum] and RPExtraTeams[beforeNum].name == "SCP 966" then
      scp966_ply = nil
      timer.Remove("luctus_repair_movespeed")
      net.Start("luctus_scp966_nodraw")
        net.WriteEntity(nil)
      net.Broadcast()
    end
  end)
  
  hook.Add("PlayerDisconnected", "luctus_scp966_plynil", function(ply)
    if ply == scp966_ply then
      scp966_ply = nil
      net.Start("luctus_scp966_nodraw")
        net.WriteEntity(nil)
      net.Broadcast()
    end
  end)
  
  hook.Add("PlayerSpawn", "luctus_scp966_nodraw", function(ply)
    timer.Simple(1,function()--im lazy
      if scp966_ply then
        net.Start("luctus_scp966_nodraw")
          net.WriteEntity(scp966_ply)
        net.Broadcast()
      end
    end)
  end)
  function luctusRepairMoveSpeed()
    for k,ply in pairs(player.GetAll()) do
      if not ply.loldWalkSpeed then continue end
      if ply.loldWalkSpeed == ply:GetWalkSpeed() and ply.loldRunSpeed == ply:GetRunSpeed() then 
        ply.loldWalkSpeed = nil
        ply.loldRunSpeed = nil
        continue
      end
      if ply.loldWalkSpeed > ply:GetWalkSpeed() then
        ply:SetWalkSpeed(math.min(ply.loldWalkSpeed,ply:GetWalkSpeed()+ply.loldWalkSpeed/800))
        ply:SetRunSpeed(math.min(ply.loldRunSpeed,ply:GetRunSpeed()+ply.loldRunSpeed/800))
      end
    end
  end
end

print("[SCP966] SH Loaded!")