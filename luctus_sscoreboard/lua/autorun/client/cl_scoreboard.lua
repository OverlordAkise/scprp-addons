--Luctus SCP Scoreboard
--Made by OverlordAkise

local LUCTUS_SCOREBOARD_NAME = "Luctus SCPRP"
local LUCTUS_SCOREBOARD_WEBSITE = "https://luctus.at"

--Custom colors and names for groups
local cgroups = {
    ["superadmin"] = { "Super Administrator", Color( 199, 44, 44 ) },
    ["developer"] = { "Developer", Color( 199, 44, 44 ) },
    ["admin"] = { "Administrator", Color( 241, 196, 15 ) },
    ["moderator"] = { "Moderator", Color( 52, 152, 219 ) },
    ["donator"] = { "Donator", Color( 155, 89, 182 ) },
    ["vip"] = { "VIP", Color( 155, 89, 182 ) }
}

--Rightclick options for players
local scoreboard_admin_options = {
    ["copy steamid"] = function(v) SetClipboardText(v:SteamID()) end,
    ["copy steamid64"] = function(v) SetClipboardText(v:SteamID64()) end,
    ["ulx bring"] = function(v) RunConsoleCommand("ulx", "bring", v:Nick()) end,
    ["ulx return"] = function(v) RunConsoleCommand("ulx", "return", v:Nick()) end,
    ["ulx freeze"] = function(v) RunConsoleCommand("ulx", "freeze", v:Nick()) end,
    ["ulx unfreeze"] = function(v) RunConsoleCommand("ulx", "unfreeze", v:Nick()) end,
    ["ulx jail"] = function(v) RunConsoleCommand("ulx", "jail", v:Nick()) end,
    ["ulx unjail"] = function(v) RunConsoleCommand("ulx", "unjail", v:Nick()) end,
    ["ulx spectate"] = function(v) RunConsoleCommand("ulx", "spectate", v:Nick()) end,
}

--------------------------
-- End of configuration --
--------------------------

local ScoreFrame = nil
  

surface.CreateFont( "LuctusScoreFontBig", { font = "Montserrat", size = 35, weight = 800, antialias = true, bold = true })
surface.CreateFont( "LuctusScoreFontSmall", { font = "Montserrat", size = 20, weight = 700, antialias = true, bold = true })

--New Design
local backgroundColLight = Color(26,26,26,180)
local color_black = Color(0,0,0)
local color_white = Color(255,255,255)

local function lLuctusDrawEdgeBox(x, y, w, h, s, b)
    if not s then s = 10 end
    if not b then b = 2 end
    surface.SetDrawColor(backgroundColLight)
    surface.DrawRect(x,y,w,h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(x,y,s,b)
	surface.DrawRect(x,y+b,b,s-b)
	local xr = x+w
	surface.DrawRect(xr-s,y,s,b)
	surface.DrawRect(xr-b,y+b,b,s-b)
	local yb = y+h
	surface.DrawRect(xr-s,yb-b,s,b)
	surface.DrawRect(xr-b,yb-s,b,s-b)
	surface.DrawRect(x,yb-b,s,b)
	surface.DrawRect(x,yb-s,b,s-b)
end


local function surfaceDrawRectCol( x, y, w, h, col )
    surface.SetDrawColor( col )
    surface.DrawRect( x, y, w, h )
end

local function CreateScoreboard()
    if ScoreFrame then ScoreFrame:Close() end
    ScoreFrame = vgui.Create("DFrame")
    ScoreFrame:SetSize( 1000, 700 )
    ScoreFrame:SetTitle("")
    ScoreFrame:SetDraggable( false )
    ScoreFrame:SetVisible( true )
    ScoreFrame:ShowCloseButton( false )
    ScoreFrame:Center()
    gui.EnableScreenClicker( true )
    function ScoreFrame:Paint(w, h)
        lLuctusDrawEdgeBox(0,0,w,h)
        draw.DrawText("Name", "LuctusScoreFontSmall", 51, 77, COLOR_WHITE)
        draw.DrawText("Job", "LuctusScoreFontSmall", 331, 77, COLOR_WHITE, TEXT_ALIGN_LEFT)
        draw.DrawText("Rank", "LuctusScoreFontSmall", 509, 77, COLOR_WHITE)
        draw.DrawText("Kills", "LuctusScoreFontSmall", 750, 77, COLOR_WHITE)
        draw.DrawText("Deaths", "LuctusScoreFontSmall", 810, 77, COLOR_WHITE)
        draw.DrawText("Ping", "LuctusScoreFontSmall", 890, 77, COLOR_WHITE)
        draw.DrawText(LUCTUS_SCOREBOARD_NAME, "LuctusScoreFontBig", w / 2, 5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER)
        --draw.DrawText("There are currently " .. #player.GetAll() .. " player(s) online.", "LuctusScoreFontSmall", w / 2, h - 21, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end

    local website = vgui.Create("DLabel", ScoreFrame)
    surface.SetFont("LuctusScoreFontSmall")
    local offsetX, offsetY = surface.GetTextSize(LUCTUS_SCOREBOARD_WEBSITE)
    offsetX = offsetX + 10
    offsetY = offsetY + 4
    website:SetPos(ScoreFrame:GetWide() / 2 - (offsetX/2), 45)
    website:SetSize(offsetX, offsetY)
    website:SetFont("LuctusScoreFontSmall")
    website:SetTextColor(color_white)
    website:SetText(LUCTUS_SCOREBOARD_WEBSITE)
    website:SetCursor("hand")
    website:SetMouseInputEnabled( true )
    website.OnMousePressed = function()
        gui.OpenURL(LUCTUS_SCOREBOARD_WEBSITE)
    end

    ScoreFrame.PlayerList = vgui.Create("DPanelList", ScoreFrame)
    ScoreFrame.PlayerList:SetSize(ScoreFrame:GetWide() - 20, ScoreFrame:GetTall() - 130)
    ScoreFrame.PlayerList:SetPos(10, 110)
    ScoreFrame.PlayerList:SetSpacing(2)
    ScoreFrame.PlayerList:EnableVerticalScrollbar(true)
    --ScoreFrame.PlayerList:SetStretchHorizontally( false )

    ScoreFrame.PlayerList.Paint = function( me, w, h )
        --surfaceDrawRectCol( 0, 0, w, h, Color( 26, 26, 26, 200 ) )
        lLuctusDrawEdgeBox(0,0,w,h,5,1)
    end

    local sbar = ScoreFrame.PlayerList.VBar
    function sbar:Paint( w, h )
        surfaceDrawRectCol( 0, 0, w, h, Color( 0, 0, 0, 100 ) )
    end
    function sbar.btnUp:Paint( w, h )
        surfaceDrawRectCol( 0, 0, w, h, Color( 44, 44, 44 ) )
    end
    function sbar.btnDown:Paint( w, h )
        surfaceDrawRectCol( 0, 0, w, h, Color( 44, 44, 44 ) )
    end
    function sbar.btnGrip:Paint( w, h )
        surfaceDrawRectCol( 0, 0, w, h, Color( 56, 56, 56 ) )
    end
    
    for k, v in pairs(player.GetAll()) do
        local item = vgui.Create("DLabel", ScoreFrame.PlayerList)
        item:SetSize(ScoreFrame.PlayerList:GetWide() - 70, 30)
        item:SetCursor("hand")

        item.Paint = function( me, w, h )
            if not IsValid(v) then item:Remove() return end
            if k % 2 == 0 then
                lLuctusDrawEdgeBox(0,0,w,h,5,1)
            else
                lLuctusDrawEdgeBox(0,0,w,h,5,1  )
            end
            local ugrp = v:GetUserGroup()
            draw.DrawText(v:Nick(), "LuctusScoreFontSmall", 40, 4, Color(255,255,255))
            draw.DrawText(v:getDarkRPVar("job"), "LuctusScoreFontSmall", 320, 4, team.GetColor(v:Team()),TEXT_ALIGN_LEFT)
            draw.DrawText(cgroups[ugrp] and cgroups[ugrp][1] or ugrp, "LuctusScoreFontSmall", 500, 3, cgroups[ugrp] and cgroups[ugrp][2] or Color(255,255,255))
            draw.DrawText(v:Frags() < 0 and 0 or v:Frags(), "LuctusScoreFontSmall", 739, 4, Color( 255, 255, 255 ))
            draw.DrawText(v:Deaths(), "LuctusScoreFontSmall", 799, 4, Color(255, 255, 255))
            draw.DrawText(v:Ping(), "LuctusScoreFontSmall", 879, 4, Color(255, 255, 255))
        end
        item.ply = v
        item.DoRightClick = function()
            if IsValid( Inspect ) then
                Inspect:Remove()
            end
            Inspect = DermaMenu()
            for k,v in SortedPairs(scoreboard_admin_options) do
                Inspect:AddOption(k)
            end
            function Inspect:OptionSelected(option, optionText)
                if scoreboard_admin_options[optionText] ~= nil then
                    scoreboard_admin_options[optionText](v)
                end
            end
            Inspect:Open()
        end

        local image = vgui.Create( "AvatarImage", item )
        image:SetSize( 28, 28 )
        image:SetPos( 1, 1 )
        image:SetPlayer( v, 32 )

        local mute = vgui.Create( "DImageButton", item )
        mute:SetSize( 16, 16 )
        mute:SetPos(item:GetWide() + 35, 7 )
        mute:SetImage( v:IsMuted() and "icon16/sound_mute.png" or "icon16/sound.png" )

        mute.DoClick = function()
            if !v:IsMuted() then v:SetMuted( true ) else v:SetMuted( false ) end
            mute:SetImage( v:IsMuted() and "icon16/sound_mute.png" or "icon16/sound.png" )
        end

        ScoreFrame.PlayerList:AddItem( item )
    end
    ScoreFrame:SlideDown(0.2) 
end


hook.Add("ScoreboardShow", "luctus_create_scoreboard", function()
    CreateScoreboard()
    return true
end)

hook.Add("ScoreboardHide", "luctus_hide_scoreboard", function()
    if IsValid( ScoreFrame ) then 
        --ScoreFrame:SetVisible(false)
        ScoreFrame:SlideUp(0.2) 
        gui.EnableScreenClicker(false)
    end
    if IsValid( Inspect ) then Inspect:Remove() end
    return true
end)

-- Fix for removing default Scoreboard B-)
local function repairScoreboard()
    hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
    hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
    timer.Simple(3,function()
        hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
        hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
    end)
end

hook.Add("OnGamemodeLoaded", "luctus_override_FAdmin_scoreboard", repairScoreboard)
hook.Add("DarkRPFinishedLoading", "luctus_override_FAdmin_scoreboard", repairScoreboard)

print("[luctus_scoreboard] cl loaded")
