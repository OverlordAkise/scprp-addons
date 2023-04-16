--Luctus SCP966 System
--Made by OverlordAkise

--This is only for Night Vision

local NightVisionJobs = {
    ["MTF"] = true,
    ["Gun Dealer"] = true,
    ["Citizen"] = true,
    ["SCP 966"] = true,
}

local flashEnabled = false

function IsNightVisionActive()
    return flashEnabled
end

CreateClientConVar("luctus_fullbright", "0", true, false, "Toggles fullbright mode, making the whole map light up like a christmas tree", 0, 1)
RunConsoleCommand("luctus_fullbright","0")
hook.Add("InitPostEntity","luctus_fullbright_default",function()
    RunConsoleCommand("luctus_fullbright","0")
end)

cvars.AddChangeCallback("luctus_fullbright", function(convar_name, value_old, value_new)
    if LocalPlayer().getDarkRPVar and LocalPlayer():getDarkRPVar("job") and not NightVisionJobs[LocalPlayer():getDarkRPVar("job")] then
        print("You don't have nightvision goggles!")
        return
    end
    if value_new == "0" then
        flashEnabled = false
        hook.Remove("RenderScreenspaceEffects", "luctus_nv")
        if scp966_ply and IsValid(scp966_ply) then
            scp966_ply:SetNoDraw(true)
        end
    end
    if value_new == "1" then
        local tab = {
            ["$pp_colour_addr"] = 0.00,
            ["$pp_colour_addg"] = 0.3,
            ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = 0,
            ["$pp_colour_contrast"] = 1,
            ["$pp_colour_colour"] = 1,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0
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
        if not NightVisionJobs[RPExtraTeams[LocalPlayer():Team()].name] then
            chat.AddText("You don't have nightvision goggles!")
            return
        end
        if flashEnabled then
            RunConsoleCommand("luctus_fullbright","0")
        else
            RunConsoleCommand("luctus_fullbright","1")
        end
    end
end)


hook.Add( "PreRender", "platflash", function()
    if not flashEnabled then
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
    if not flashEnabled then return end
    render.SetLightingMode(0)
end)

hook.Add("PostDrawEffects", "FixFullbrightOnEffects", function()
    if not flashEnabled then return end
    render.SetLightingMode(0)
end)

hook.Add( "PreDrawOpaqueRenderables", "FixFullbrightOpaqueRenderables", function(boolDrawingDepth, boolDrawingSkybox)
    if not flashEnabled then return end
    render.SetLightingMode(0)
end)

hook.Add("PreDrawSkyBox", "ImproveSkyboxFlickering", function()
    if not flashEnabled then return end
end)

hook.Add( "SetupWorldFog", "ForceFullbrightWorld", function()
    if not flashEnabled then
        return 
    end
    render.SuppressEngineLighting(true)
    render.SetLightingMode(1)
    render.SuppressEngineLighting(false)
end)

hook.Add("PostDrawTranslucentRenderables", "FixFullbrightOnTranslucentRenders", function(boolDrawingDepth, boolDrawingSkybox)
    if not flashEnabled then return end
    render.SetLightingMode(0)
end)

print("[SCP966] CL loaded!")
