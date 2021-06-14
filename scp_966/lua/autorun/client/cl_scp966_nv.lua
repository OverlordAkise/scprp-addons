--Luctus SCP966 System
--Made by OverlordAkise

--This is only for Night Vision

local flashEnabled = false

function IsNightVisionActive()
  return flashEnabled
end

CreateClientConVar("luctus_fullbright", "0", true, false, "Toggles fullbright mode, making the whole map light up like a christmas tree", 0, 1)

cvars.AddChangeCallback("luctus_fullbright", function(convar_name, value_old, value_new)
  if value_new == "0" then
    flashEnabled = false
    hook.Remove("RenderScreenspaceEffects", "luctus_nv")
    if scp966_ply and IsValid(scp966_ply) then
      scp966_ply:SetNoDraw(true)
    end
  end
  if value_new == "1" then
    local tab = {
      [ "$pp_colour_addr" ] = 0.00,
      [ "$pp_colour_addg" ] = 0.3,
      [ "$pp_colour_addb" ] = 0,
      [ "$pp_colour_brightness" ] = 0,
      [ "$pp_colour_contrast" ] = 1,
      [ "$pp_colour_colour" ] = 1,
      [ "$pp_colour_mulr" ] = 0,
      [ "$pp_colour_mulg" ] = 0,
      [ "$pp_colour_mulb" ] = 0
    }
    hook.Add("RenderScreenspaceEffects", "luctus_nv", function() DrawColorModify( tab ) end)
    flashEnabled = true
    if scp966_ply and IsValid(scp966_ply) then
      scp966_ply:SetNoDraw(false)
    end
  end
end)




hook.Add("OnPlayerChat","luctus_fullbright",function(ply,text,team,bdead)
  if ply == LocalPlayer() and text == "!nv" then
    if flashEnabled then
      RunConsoleCommand("luctus_fullbright","0")
    else
      RunConsoleCommand("luctus_fullbright","1")
    end
  end
end)


hook.Add( "PreRender", "platflash", function()
	if !flashEnabled then
		render.SetLightingMode(0)
		return
	end
	render.SetLightingMode(1)
	render.SuppressEngineLighting(false)
end)

hook.Add("PostRender", "platflash", function()
	render.SetLightingMode(0)
	render.SuppressEngineLighting(false)
end)

hook.Add("PreDrawHUD", "FixFullbrightOnHUD", function()
	render.SetLightingMode(0)
end)

hook.Add("PreDrawEffects", "FixFullbrightOnEffects", function()
	if !flashEnabled then return end
	render.SetLightingMode(0)
end)

hook.Add("PostDrawEffects", "FixFullbrightOnEffects", function()
	if !flashEnabled then return end
	render.SetLightingMode(0)
end)

hook.Add( "PreDrawOpaqueRenderables", "FixFullbrightOpaqueRenderables", function(boolDrawingDepth, boolDrawingSkybox)
	if !flashEnabled then return end
	render.SetLightingMode(0)
end)

hook.Add("PreDrawSkyBox", "ImproveSkyboxFlickering", function()
	if !flashEnabled then return end
end)

hook.Add( "SetupWorldFog", "ForceFullbrightWorld", function()
	if !flashEnabled then
		return 
	end
	render.SuppressEngineLighting(true)
	render.SetLightingMode(1)
	render.SuppressEngineLighting(false)
end)

hook.Add("PostDrawTranslucentRenderables", "FixFullbrightOnTranslucentRenders", function(boolDrawingDepth, boolDrawingSkybox)
	if !flashEnabled then return end
	render.SetLightingMode(0)
end)



--NoDraw SCP966 Stuff here
scp966_ply = scp966_ply or nil

net.Receive("luctus_scp966_nodraw",function()
  scp966_ply = net.ReadEntity()
  if scp966_ply and IsValid(scp966_ply) then
    if not flashEnabled then
      scp966_ply:SetNoDraw(true)
    end
  else
    for k,v in pairs(player.GetAll()) do
      v:SetNoDraw(false)
    end
  end
end)

print("[SCP966] CL loaded!")
