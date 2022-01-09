--Luctus SCP966 System
--Made by OverlordAkise

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
