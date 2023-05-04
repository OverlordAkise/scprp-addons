--Luctus Noclip
--Made by OverlordAkise

surface.CreateFont("luctus_noclip",{
    font = "Verdana",
    size = 90,
    weight = 500,
})

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)

net.Receive("luctus_noclip",function()
    if net.ReadBool() then
        hook.Add("HUDPaint","luctus_noclip",LuctusNoclipHud)
    else
        hook.Remove("HUDPaint","luctus_noclip")
    end
end)

function LuctusNoclipHud()
    draw.SimpleTextOutlined(utf8.char(9992), "luctus_noclip",ScrW()/2, ScrH()-100,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,color_black)
end

print("[luctus_noclip] cl loaded")
