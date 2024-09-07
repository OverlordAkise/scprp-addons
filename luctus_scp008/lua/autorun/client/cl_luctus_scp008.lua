--Luctus SCP008 System
--Made by OverlordAkise

local drawing = false

net.Receive("luctus_scp008_infection",function()
    if net.ReadBool() then
        if not drawing then
            surface.PlaySound("ambient/voices/cough2.wav")
        end
        hook.Add("HUDPaint","luctus_scp008_infection",DrawSCP008Infection)
        drawing = true
    else
        hook.Remove("HUDPaint","luctus_scp008_infection")
        drawing = false
    end
end)


function DrawSCP008Infection()
    local inf = LocalPlayer():GetNW2Float("luctus_scp008_infection",0)
    draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(55,0,0,inf*1.5))
    if LUCTUS_SCP008_DEBUG then
        draw.SimpleTextOutlined(inf, "DermaLarge", ScrW()*0.5, ScrH()*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 5, color_black)
    end
end

print("[luctus_scp008] cl loaded")
