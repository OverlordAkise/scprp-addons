--Luctus SCP HUD
--Made by OverlordAkise

surface.CreateFont( "LucidHUDFont", { font = "Consolas", size = 18, weight = 0 } )
surface.CreateFont( "LucidAmmoFont", { font = "Consolas", size = 48, weight = 0 } )

local hungerModEnabled = false
local hmPad = 0

hook.Add("InitPostEntity","luctus_shud_hunger",function()
    if not DarkRP.disabledDefaults["modules"]["hungermod"] then
        hungerModEnabled = true
        hmPad = 30
        print("[luctus_sHUD] hungermod support enabled")
    end
end)

hook.Add("OnPlayerChangedTeam","luctus_shud_hunger",function(ply,b,a)
    if not DarkRP.disabledDefaults["modules"]["hungermod"] then
        if LUCTUS_SHUD_HUNGERFREE[team.GetName(a)] then
            hungerModEnabled = false
            hmPad = 0
        else
            hungerModEnabled = true
            hmPad = 30
        end
    end
end)

local disabledHUDs = {
    ["DarkRP_HUD"] = true,
    ["CHudBattery"] = true,
    ["CHudHealth"] = true,
    ["DarkRP_Hungermod"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudAmmo"] = true,
}

hook.Add("HUDShouldDraw", "luctus_shud_disabledefaulthud", function(vs)
    if disabledHUDs[vs] then return false end
end)

local function CreateImageIcon( icon, x, y, col, val )
    surface.SetDrawColor( col )
    surface.SetMaterial( icon )
    local w, h = 16, 16
    if val then
        surface.SetDrawColor( color_white )
    end
    surface.DrawTexturedRect( x, y, w, h )
end

--local vars for HUD
local scrw = ScrW()
local scrh = ScrH()
local startX = 30
local startY = scrh-185
local baseWidth = 260
local baseHeight = 120

local barX = 20
local barY = startY + 50
local maxBarSize = 220
local barHeight = 24

local backgroundCol = Color(26,26,26,120)
local backgroundColLight = Color(26,26,26,90)
local color_black = Color(0,0,0)
local color_white = Color(255,255,255)
local hpCol = Color(200, 20, 60, 190)
local armorCol = Color(30, 144, 190)
local healthCol = Color(255, 0, 0)
local hungerCol = Color(215,155,0)

local blur = Material( "pp/blurscreen" )
function LuctusDrawBlur( x, y, w, h, layers, density, alpha )
    surface.SetDrawColor( 255, 255, 255, alpha )
    surface.SetMaterial( blur )
    for i = 1, layers do
        blur:SetFloat( "$blur", ( i / layers ) * density )
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect( x, y, x + w, y + h, true )
        surface.DrawTexturedRect( 0, 0, scrw, scrh )
        render.SetScissorRect( 0, 0, 0, 0, false )
    end
end

function LuctusDrawEdgeBox(x, y, w, h, s, b)
    if not s then s = 10 end
    if not b then b = 2 end
    surface.SetDrawColor(backgroundColLight)
    surface.DrawRect(x,y,w,h)
    LuctusDrawBlur(x,y,w,h,10,5,255)
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

hook.Add( "HUDPaint", "luctus_hud", function()
    local ply = LocalPlayer()
    --MainBox
    LuctusDrawEdgeBox(startX,startY,baseWidth,baseHeight+hmPad)
    --Job
    surface.SetFont("LucidHUDFont")
    draw.SimpleText(ply:Nick(), "LucidHUDFont", startX+20, startY + 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText( ply:getDarkRPVar("job"), "LucidHUDFont", startX+20, startY + 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    --backgrounds
    surface.SetDrawColor(backgroundCol)
    surface.DrawRect(startX+barX, barY, maxBarSize, barHeight)
    surface.DrawRect(startX+barX, barY + 28, maxBarSize, barHeight)
    --HP
    surface.SetDrawColor(hpCol)
    surface.DrawRect(startX+barX, barY, math.Clamp((ply:Health()*maxBarSize)/ply:GetMaxHealth(),0,maxBarSize), barHeight)
    draw.SimpleText(ply:Health() > 0 and ply:Health() or 0, "LucidHUDFont", startX+barX+(maxBarSize/2), barY + 4, color_white, TEXT_ALIGN_CENTER)
    --Armor
    surface.SetDrawColor(armorCol)
    surface.DrawRect(startX+barX, barY + 28, math.Clamp((ply:Armor()*maxBarSize)/ply:GetMaxArmor(),0,maxBarSize), barHeight)
    draw.SimpleText(ply:Armor() > 0 and ply:Armor() or 0, "LucidHUDFont", startX+barX+(maxBarSize/2), barY + 32, color_white, TEXT_ALIGN_CENTER)
    --Icons
    --CreateImageIcon(health_icon, 104, startY + 54, healthCol)
    --Hunger
    if hungerModEnabled then
        surface.SetDrawColor(backgroundCol)
        surface.DrawRect(startX+barX, barY + 56, maxBarSize, barHeight)
        surface.SetDrawColor(hungerCol)
        surface.DrawRect(startX+barX, barY + 56, ((LocalPlayer():getDarkRPVar("Energy")*maxBarSize)/100), barHeight)
        draw.SimpleText(ply:getDarkRPVar("Energy"), "LucidHUDFont", startX+barX+(maxBarSize/2), barY+60, color_white, TEXT_ALIGN_CENTER)
    end
    local wep = ply:GetActiveWeapon()
    if wep:IsValid() then
        local veh = ply:GetVehicle()
        if IsValid(veh) and not ply:GetAllowWeaponsInVehicle() then return end
        local wep_name = wep:GetPrintName() or wep:GetClass() or "<UNKNOWN>"
        local ammo_type = wep:GetPrimaryAmmoType()
        if ammo_type == -1 then
            LuctusDrawEdgeBox(scrw-245, scrh-170, 200, 30)
            draw.SimpleText(wep_name, "LucidHUDFont", scrw-235, scrh-155, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        if ammo_type ~= -1 then
            LuctusDrawEdgeBox(scrw-245, scrh-170, 200, 105)
            draw.SimpleText(wep_name, "LucidHUDFont", scrw-235, scrh-150, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(wep:Clip1(), "LucidAmmoFont", scrw-145, scrh-145, color_white, TEXT_ALIGN_RIGHT)
            draw.SimpleText(ply:GetAmmoCount(ammo_type), "LucidHUDFont", scrw-100, scrh-113, color_white, TEXT_ALIGN_RIGHT)
            surface.SetDrawColor(color_white)
            surface.DrawRect(scrw-240,scrh-90,math.Clamp((wep:Clip1()*190)/wep:GetMaxClip1(),0,190),20)
        end
    end
    --agenda
    local agenda = ply:getAgendaTable()
    if agenda then
        agendaText = DarkRP.textWrap((ply:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 440)
        
        LuctusDrawEdgeBox(12, 22, 456, 106)
        
        draw.DrawNonParsedText(agenda.Title, "LucidHUDFont", 30, 22, color_white, 0)
        draw.DrawNonParsedText(agendaText, "LucidHUDFont", 30, 45, color_white, 0)
    end
    --lockdown
    if GetGlobalBool("DarkRP_LockDown") then
        local cin = math.Clamp(math.abs(math.sin(CurTime()/5) * scrw),0,scrw-100)
        draw.DrawNonParsedText("LOCKDOWN", "Trebuchet24", cin, scrh-25, color_white, TEXT_ALIGN_LEFT)
    end
    --arrested
    if ply:getDarkRPVar("Arrested") then
        draw.SimpleTextOutlined("You are in jail!", "Trebuchet24", scrw*0.5, scrh*0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
    end
end)

print("[luctus_hud] hud loaded")
