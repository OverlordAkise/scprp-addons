--Luctus SCP966 System
--Made by OverlordAkise


--Vision for scp966
hook.Add("OnPlayerChangedTeam","luctus_fullbright_reset", function(ply, beforeNum, afterNum)
    if string.EndsWith(team.GetName(afterNum),"966") then
        LUCTUS_SCP966_NV_ENABLED = true
        hook.Add("PreDrawHalos", "luctus_scp966_halo",LuctusSCP966Halo)
    else
        LUCTUS_SCP966_NV_ENABLED = false
        hook.Remove("PreDrawHalos", "luctus_scp966_halo")
    end
end)

--NoDraw SCP966 Stuff here
scp966_ply = scp966_ply or nil
net.Receive("luctus_scp966_get",function()
    scp966_ply = net.ReadEntity()
end)

hook.Add("PrePlayerDraw","luctus_scp966_hideply",function(ply)
    if scp966_ply ~= ply then return end
    if LUCTUS_SCP966_NV_ENABLED then return end
    ply:DrawShadow(false)
    return true
end)

--Get scp966ply if joining
hook.Add("InitPostEntity","luctus_scp966_getinit",function()
    net.Start("luctus_scp966_get")
    net.SendToServer()
end)

--Code for highlighting player in a halo (around body)
--TODO: This doesnt work as WalkSpeed is not networked to clients :-(
local red = Color(255,0,0)
local green = Color(0,255,0)
function LuctusSCP966Halo()
    local ply = LocalPlayer():GetEyeTrace().Entity
    if IsValid(ply) and ply:IsPlayer() then
        local speed = ply:GetWalkSpeed()
        halo.Add({ply}, speed > LUCTUS_SCP966_WALKSPEEDNEEDED and red or green , 1, 1, 5, true, true )
    end
end

LUCTUS_SCP966_NV_ENABLED = LUCTUS_SCP966_NV_ENABLED or false

function LuctusSCP966ToggleNV()
    LUCTUS_SCP966_NV_ENABLED = not LUCTUS_SCP966_NV_ENABLED
end

local LightingModeChanged = false
hook.Add("PreRender","fullbright",function()
    if not LUCTUS_SCP966_NV_ENABLED then return end
	render.SetLightingMode(1)
	LightingModeChanged = true
end)

local function EndOfLightingMod()
	if LightingModeChanged then
		render.SetLightingMode(0)
		LightingModeChanged = false
	end
end
hook.Add("PostRender","fullbright",EndOfLightingMod)
hook.Add("PreDrawHUD","fullbright",EndOfLightingMod)


local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.2,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_colour"] = 1.1,
	["$pp_colour_contrast"] = 1.1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

hook.Add("RenderScreenspaceEffects", "luctus_scp966", function()
    if not LUCTUS_SCP966_NV_ENABLED then return end
	DrawColorModify(tab)
end)

hook.Add("OnPlayerChat","luctus_fullbright",function(ply,text,pteam,bdead)
    if ply ~= LocalPlayer() or text ~= "!nv" then return end
    if not LUCTUS_SCP966_NV_JOBS[team.GetName(LocalPlayer():Team())] then
        chat.AddText("You don't have nightvision goggles!")
        return
    end
    LuctusSCP966ToggleNV()
end)

print("[scp966] cl loaded")
