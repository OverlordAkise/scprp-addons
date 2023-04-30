--Luctus SCP HUD
--Made by OverlordAkise

if not LUCTUS_SHUD_NOTIFICATION_SHOULDLOAD then return end

local color_white = Color(255,255,255)
local Colors = {}
Colors[NOTIFY_GENERIC] = Color(52, 73, 94)
Colors[NOTIFY_ERROR] = Color(192, 57, 43)
Colors[NOTIFY_UNDO] = Color(41, 128, 185)
Colors[NOTIFY_HINT] = Color(39, 174, 96)
Colors[NOTIFY_CLEANUP] = Color(243, 156, 18)
local LoadingColor = Color(22, 160, 133)

local Icons = {}
Icons[NOTIFY_GENERIC] = Material("vgui/notices/generic")
Icons[NOTIFY_ERROR] = Material("vgui/notices/error")
Icons[NOTIFY_UNDO] = Material("vgui/notices/undo")
Icons[NOTIFY_HINT] = Material("vgui/notices/hint")
Icons[NOTIFY_CLEANUP] = Material("vgui/notices/cleanup")
local LoadingIcon = Material("vgui/notices/cleanup")

local Notifications = {}

local function DrawNotification(x, y, w, h, text, icon, col, progress)
    LuctusDrawEdgeBox(x,y,w,h)

    draw.SimpleText(text, "Trebuchet24", x + 32 + 10, y + h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(icon)

    if progress then
        surface.DrawTexturedRectRotated(x + 16, y + h / 2, 16, 16, -CurTime() * 360 % 360)
    else
        surface.DrawTexturedRect(x + 8, y + 8, 16, 16)
    end
end

function notification.AddLegacy( text, type, time )
    surface.SetFont( "Trebuchet24" )
    table.insert( Notifications, 1, {
        x = ScrW(),
        y = ScrH()-200,
        w = surface.GetTextSize( text ) + 20 + 32,
        h = 32,
        text = text,
        col = Colors[ type ],
        icon = Icons[ type ],
        time = CurTime() + time,
        progress = nil,
    })
end

function notification.AddProgress(id, text, frac)
    for k,v in ipairs(Notifications) do
        if v.id == id then
            v.text = text
            v.progress = frac
            return
        end
    end
    surface.SetFont("Trebuchet24")
    table.insert(Notifications, 1, {
        x = ScrW(),
        y = ScrH()-200,
        w = surface.GetTextSize( text ) + 20 + 32,
        h = 32,
        id = id,
        text = text,
        col = LoadingColor,
        icon = LoadingIcon,
        time = math.huge,
        progress = math.Clamp( frac or 0, 0, 1 ),
    })    
end

function notification.Kill( id )
    for k,v in ipairs(Notifications) do
        if v.id == id then v.time = 0 end
    end
end

hook.Add("HUDPaint", "luctus_shud_notifications", function()
    for k,v in ipairs(Notifications) do
        DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, v.col, v.progress)

        v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1)
        v.y = Lerp(FrameTime() * 10, v.y, (ScrH()-200)-(k-1)*(v.h+5))
    end

    for k,v in ipairs(Notifications) do
        if v.x >= ScrW() and v.time < CurTime() then
            table.remove(Notifications, k)
        end
    end
end)

print("[luctus_hud] notif loaded!")
