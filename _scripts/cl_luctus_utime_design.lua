--Luctus UTime Design
--Made by OverlordAkise

local uFont = "DermaDefault"
local xPadding = 18
local utime_pos_x = CreateClientConVar( "utime_pos_x", "0.0", true, false )
local utime_pos_y = CreateClientConVar( "utime_pos_y", "0.0", true, false )

local color_white = Color(255,255,255)
local darkRed = Color(250, 20, 60, 190)
local backgroundColLight = Color(26,26,26,140)
local accent = Color(255,0,0)
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

hook.Add("InitPostEntity","luctus_utime",function()
    RunConsoleCommand("utime_enable","0")
end)

hook.Add("HUDPaint","luctus_utime",function()
    local x = utime_pos_x:GetFloat()
    local y = utime_pos_y:GetFloat()
    
    local t = os.date("%d.%m.%Y %H:%M:%S")
    lLuctusDrawEdgeBox(x,y,180,45)
    draw.SimpleText("Time:     "..t,uFont,x+xPadding,y+3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
    draw.SimpleText("Session: "..Utime.timeToStr(LocalPlayer():GetUTimeSessionTime()),uFont,x+xPadding,y+27,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
    draw.SimpleText("Total:     "..Utime.timeToStr(LocalPlayer():GetUTime()),uFont,x+xPadding,y+15,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
end)

print("[luctus_utime] Loaded new design!")
