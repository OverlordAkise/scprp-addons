--Luctus Airsoft
--Made by OverlordAkise

local color_red = Color(255,0,0)
local color_green = Color(0,255,0)

hook.Add("HUDPaint","luctus_airsoft_hp",function()
    local ply = LocalPlayer()
    local hp = ply:GetNWInt("luctus_airsoft_hp",100)
    if ply:GetNWBool("luctus_airsoft_active",false) then
        draw.SimpleTextOutlined(math.max(hp,0), "DermaLarge", ScrW()/2, ScrH()*0.75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end
    if hp < 1 then
        draw.SimpleTextOutlined("UNCONSCIOUS", "DermaLarge", ScrW()/2, ScrH()*0.6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end
end)

print("[luctus_airsoft] cl loaded!")
