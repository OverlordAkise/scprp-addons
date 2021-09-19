--Luctus SCP096 System
--Made by OverlordAkise

local red_material = CreateMaterial("luctus_red", "VertexLitGeneric", { ["$basetexture"] = "models/debug/debugwhite", ["$model"] = 1, ["$ignorez"] = 1 })

local col = Color(255,0,0)

scp096_hunted_players = {}

net.Receive("luctus_scp096_update",function()
  scp096_hunted_players = net.ReadTable()
end)

hook.Add("OnPlayerChangedTeam", "luctus_scp096_hunters_update", function(ply, before, after)
  if RPExtraTeams[before] and RPExtraTeams[before].name == "SCP 096" then
      scp096_hunted_players = {}
    end
end)

hook.Add("RenderScreenspaceEffects", "luctus_scp096_glow", function()
  for k,v in pairs(scp096_hunted_players) do
    cam.Start3D( EyePos(), EyeAngles() )

        cam.IgnoreZ( true )
        render.MaterialOverride( red_material )
        render.SuppressEngineLighting( true )
        render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
        render.SetBlend( 0.7 )
        v:DrawModel()
        render.SuppressEngineLighting( false )
        render.MaterialOverride()
        cam.IgnoreZ( false )

    cam.End3D()
  end
end)

print("[SCP096] CL loaded!")
