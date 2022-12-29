--Luctus SCP008 System
--Made by OverlordAkise

net.Receive("luctus_scp008_infection",function()
    local shouldStart = net.ReadBool()
    if shouldStart then
        hook.Add("HUDPaint","luctus_scp008_infection",DrawSCP008Infection)
    else
        hook.Remove("HUDPaint","luctus_scp008_infection")
    end
end)


function DrawSCP008Infection()
    local col = Color(55,0,0,LocalPlayer():GetNWInt("luctus_scp008_infection",0)*1.5)
    draw.RoundedBox(0,0,0,ScrW(),ScrH(),col)
    if LUCTUS_SCP008_DEBUG then
        draw.SimpleTextOutlined(LocalPlayer():GetNWInt("luctus_scp008_infection",0), "DermaLarge", ScrW()*0.5, ScrH()*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 5, color_black)
    end
end

print("[SCP008] CL Loaded!")
