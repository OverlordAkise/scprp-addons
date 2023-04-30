--Luctus SCP HUD
--Made by OverlordAkise
if not LUCTUS_SHUD_PICKUP_SHOULDLOAD then return end

local color_white = Color(255,255,255)
local startHeight = 200
local Pickups = {}

local function DrawNotification(x, y, w, h, text, icon, col, progress)
    LuctusDrawEdgeBox(x,y,w,h)

    draw.SimpleText(text, "Trebuchet24", x + 10, y + h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local function AddPickupLine(text)
    text = "+ "..text
    surface.SetFont( "Trebuchet24" )
    table.insert( Pickups, 1, {
        x = ScrW(),
        y = startHeight,
        w = surface.GetTextSize( text ) + 20,
        h = 32,
        text = text,
        time = CurTime()+5,
        progress = nil,
    })
end

hook.Add("HUDPaint", "luctus_shud_pickup", function()
    for k,v in ipairs(Pickups) do
        DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, v.col, v.progress)

        v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1)
        v.y = Lerp(FrameTime() * 10, v.y, (startHeight)+(k-1)*(v.h+5))
    end

    for k,v in ipairs(Pickups) do
        if v.x >= ScrW() and v.time+1 < CurTime() then
            table.remove(Pickups, k)
        end
    end
end)


hook.Add("HUDItemPickedUp","luctus_shud_pickup", function(itemName)
    if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
    AddPickupLine(language.GetPhrase("#" .. itemName))
end)

hook.Add("HUDWeaponPickedUp","luctus_shud_pickup", function(wep)
    if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
    if not IsValid(wep) then return end
    if not isfunction(wep.GetPrintName) then return end
    AddPickupLine(wep:GetPrintName())
end)

hook.Add("HUDAmmoPickedUp","luctus_shud_pickup", function(itemname, amount)
    if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
    AddPickupLine(amount.." "..language.GetPhrase("#" .. itemname .. "_Ammo"))
end)

hook.Add("InitPostEntity","luctus_shud_pickup",function()
    GAMEMODE.HUDDrawPickupHistory = function()end
end)

print("[luctus_hud] pickup loaded!")
