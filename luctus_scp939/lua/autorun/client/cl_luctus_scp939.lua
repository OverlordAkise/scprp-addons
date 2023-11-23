--Luctus SCP939
--Made by OverlordAkise

--We are not using SetNoDraw on clientside because it is not working correctly
--If a player is too far away it won't "nodraw them" correctly

hook.Add("OnPlayerChangedTeam", "luctus_scp939_nodraw_plys", function(ply, beforeNum, afterNum)
    if ply ~= LocalPlayer() then return end
    
    --switch to scp939
    if string.EndsWith(RPExtraTeams[afterNum].name,"939") then
        timer.Create("luctus_scp939_main",0.5,0,LuctusSCP939MoveVisibility)
        hook.Add("PrePlayerDraw","luctus_scp939_hideply",LuctusSCP939HidePlayers)
        hook.Add("RenderScreenspaceEffects", "luctus_scp939", LuctusSCP939BadVision)
        hook.Add("PlayerEndVoice","luctus_scp939", LuctusSCP939TalkVisibilityOff)
        hook.Add("PlayerStartVoice","luctus_scp939", LuctusSCP939TalkVisibilityOn)
        hook.Add("PreDrawHalos", "luctus_scp939_halo", LuctusSCP939Halo)
        hook.Add("HUDShouldDraw","luctus_scp939_hide_overhead",LuctusSCP939HideOverhead)
        scp939_plycolors = {}
    end
    
    --switch from scp939
    if string.EndsWith(RPExtraTeams[beforeNum].name,"939") then
        for k,v in ipairs(player.GetAll()) do v:DrawShadow(true) end
        scp939_plycolors = {}
        timer.Remove("luctus_scp939_main")
        hook.Remove("PrePlayerDraw","luctus_scp939_hideply")
        hook.Remove("RenderScreenspaceEffects", "luctus_scp939")
        hook.Remove("PlayerEndVoice","luctus_scp939")
        hook.Remove("PlayerStartVoice","luctus_scp939")
        hook.Remove("PreDrawHalos", "luctus_scp939_halo")
        hook.Remove("HUDShouldDraw","luctus_scp939_hide_overhead")
    end
end)

local tab = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = -0.2,
    ["$pp_colour_colour"] = 0,
    ["$pp_colour_contrast"] = 0.2,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0,
}
function LuctusSCP939BadVision()
    DrawColorModify(tab)
end

function LuctusSCP939MakeBright()
    tab["$pp_colour_brightness"] = 0.2
    timer.Simple(LUCTUS_SCP939_SCREAM_BRIGHT_DURATION,function()
        timer.Create("luctus_scp939_brightness_decay",0.1,40,function()
            tab["$pp_colour_brightness"] = tab["$pp_colour_brightness"] - 0.01
        end)
    end)
end

function LuctusSCP939HideOverhead(a)
    if a=="DarkRP_EntityDisplay" then return false end
end

function LuctusSCP939MoveVisibility()
    local me = LocalPlayer()
    local mypos = me:EyePos()
    for k,ply in ipairs(player.GetAll()) do
        local eyepos = ply:EyePos()
        if ply == me then continue end
        if eyepos:Distance(mypos) < 2048 then
            ply:DrawShadow(false)
            if ply:GetVelocity():Length2D() > LUCTUS_SCP939_DETECT_SPEED and me:IsLineOfSightClear(eyepos) then
                LuctusSCP939AddVisiblePlayer(ply,2)
            end
        end
    end
end

net.Receive("luctus_scp939_shooting",function()
    local ply = net.ReadEntity()
    if not IsValid(ply) or not ply:IsPlayer() then return end
    LuctusSCP939AddVisiblePlayer(ply)
end)

scp939_plycolors = {}
function LuctusSCP939AddVisiblePlayer(ply,duration)
    if not IsValid(ply) then return end
    if not duration then duration = 5 end
    
    scp939_plycolors[ply] = 255
    local steamid = ply:SteamID()
    local substraction = 255/(duration*10)
    timer.Create(steamid.."_scp939",0.1,duration*10,function()
        if not IsValid(ply) then return end
        if scp939_plycolors[ply] then
            scp939_plycolors[ply] = scp939_plycolors[ply] - substraction
        end
        if timer.RepsLeft(steamid.."_scp939") == 0 then
            scp939_plycolors[ply] = nil
        end
    end)
end

function LuctusSCP939HidePlayers(ply,flags)
    if not scp939_plycolors[ply] then return true end
end

function LuctusSCP939TalkVisibilityOn(ply)
    LuctusSCP939AddVisiblePlayer(ply)
    --Add as long as they talk:
    local steamid = ply:SteamID()
    timer.Create(steamid.."_scp939_talking",1,0,function()
        if not IsValid(ply) then timer.Remove(steamid.."_scp939_talking") end
        LuctusSCP939AddVisiblePlayer(ply)
    end)
end

function LuctusSCP939TalkVisibilityOff(ply)
    timer.Remove(ply:SteamID().."_scp939_talking")
end

--Called from SpecialAttack (RMB)
function LuctusSCP939HighlightClose()
    local mypos = LocalPlayer():GetPos()
    for k,ply in ipairs(player.GetAll()) do
        if mypos:Distance(ply:GetPos()) <= LUCTUS_SCP939_SCREAM_SEARCH_DISTANCE then
            LuctusSCP939AddVisiblePlayer(ply)
        end
    end
end

--This is from my SCP096 addon
--Code for highlighting player in a halo (around body)
function LuctusSCP939Halo()
    for ply,alpha in pairs(scp939_plycolors) do
        if not IsValid(ply) then continue end
        halo.Add({ply}, Color(255,0,0,alpha), 1, 1, 5, true, true)
    end
end

print("[scp939] cl loaded")
