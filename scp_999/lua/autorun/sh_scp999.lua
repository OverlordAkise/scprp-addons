--Luctus SCP999 System
--Made by OverlordAkise

if SERVER then
  resource.AddWorkshop("1276030302") -- SCP999 orange blob model
  resource.AddWorkshop("2310758051") -- Sounds and SWEP stuff
  
  hook.Add("OnPlayerChangedTeam","luctus_scp999_view", function(ply, beforeNum, afterNum)
    if RPExtraTeams[afterNum] and RPExtraTeams[afterNum].name == "SCP 999" then
      ply:SetViewOffset(Vector(0,0,15))
      ply:SetViewOffsetDucked(Vector(0,0,15))
    end
    if RPExtraTeams[beforeNum] and RPExtraTeams[beforeNum].name == "SCP 999" then
      ply:SetViewOffset(Vector(0,0,64))
      ply:SetViewOffsetDucked(Vector(0,0,28))
    end
  end) 
end

print("[SCP999] SH Loaded!")