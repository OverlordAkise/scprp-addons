--Luctus SCP035 System
--Made by OverlordAkise

if SERVER then
  resource.AddWorkshop("268195264")
end

if CLIENT then
  local model = ClientsideModel( "models/vinrax/props/scp035/035_mask.mdl" )
  model:SetNoDraw( true )

  hook.Add( "PostPlayerDraw" , "luctus_scp035_mask" , function( ply )
    if ply:GetNWBool("isSCP035",false) then
      if not IsValid(ply) or not ply:Alive() then return end

      local attach_id = ply:LookupAttachment('eyes')
      if not attach_id then return end
          
      local attach = ply:GetAttachment(attach_id)
          
      if not attach then return end
          
      local pos = attach.Pos
      local ang = attach.Ang
        
      model:SetModelScale(1, 0)
      pos = pos + (ang:Forward() *1.4)
      pos = pos + (ang:Up() *(-1))
      ang:RotateAroundAxis(ang:Right(), 270)
      ang:RotateAroundAxis(ang:Up(), 90)
        
      model:SetPos(pos)
      model:SetAngles(ang)

      model:SetRenderOrigin(pos)
      model:SetRenderAngles(ang)
      model:SetupBones()
      model:DrawModel()
      model:SetRenderOrigin()
      model:SetRenderAngles()
      
    end 
  end)
end

if SERVER then
  
  hook.Add("OnPlayerChangedTeam","scp035_jobname_reset", function(ply, beforeNum, afterNum)
    if ply:GetNWBool("isSCP035",false) then
      ply:SetNWBool("isSCP035",false)
      local maskent = ents.Create("scp035_mask")
      maskent:SetPos(ply:GetPos())
      maskent:Spawn()
      maskent:Activate()
      if ply.loldJobName then
        ply:setDarkRPVar("job",ply.loldJobName)
        ply.loldJobName = nil
      end
    end
  end)

  hook.Add("PostPlayerDeath","scp035_spawn_mask",function(ply)
    if ply:GetNWBool("isSCP035",false) then
      ply:SetNWBool("isSCP035",false)
      local maskent = ents.Create("scp035_mask")
      maskent:SetPos(ply:GetPos())
      maskent:Spawn()
      maskent:Activate()
      if ply.loldJobName then
        ply:setDarkRPVar("job",ply.loldJobName)
        ply.loldJobName = nil
      end
    end
  end)
end

print("[SCP035] SH Loaded!")
