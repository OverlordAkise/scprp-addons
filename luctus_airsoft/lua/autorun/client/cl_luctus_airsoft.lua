--Luctus Airsoft
--Made by OverlordAkise

local color_red = Color(255,0,0)
local color_green = Color(0,255,0)

hook.Add("HUDPaint","luctus_airsoft_hp",function()
    local ply = LocalPlayer()
    if not ply:GetNWBool("luctus_airsoft_active",false) then return end
    local hp = ply:GetNWInt("luctus_airsoft_hp",-1)
    draw.SimpleTextOutlined(math.max(hp,0), "DermaLarge", ScrW()/2, ScrH()*0.75, hp > 25 and color_green or color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    if hp < 1 then
        draw.SimpleTextOutlined("BEWUSSTLOS", "DermaLarge", ScrW()/2, ScrH()*0.6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end
end)

print("[luctus_airsoft] cl loaded!")
