--SCP Code System
--Reworked by OverlordAkise

surface.CreateFont( "scpCode", {
  font = "Consolas", 
  size = 35,
  weight = 850
})

local scpCodeMaterial = scp_code_materials["green"]

net.Receive("SCPCodes", function(ply)
  scpCodeMaterial = scp_code_materials[net.ReadString()]
end)

hook.Add( "HUDPaint", "luctus_scpcode_drawpng", function()
	surface.SetMaterial(scpCodeMaterial)
  surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect( ScrW() - 256, -50, 256, 256)
end)

--Get code on join
hook.Add("InitPostEntity", "luctus_scpcode_getinit", function()
	net.Start("SCPCodes")
	net.SendToServer()
end)
