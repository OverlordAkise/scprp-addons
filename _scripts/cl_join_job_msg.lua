--Luctus Joinjob Message
--Made by OverlordAkise

--Because 3 people asked me for it already

hook.Add("InitPostEntity","luctus_joinjob_msg",function()
    hook.Add("HUDPaint","luctus_joinjob_msg",function()
        if LocalPlayer():Team() != GAMEMODE.DefaultTeam then return end
        draw.SimpleTextOutlined("Press F4 to change your job and join the RP.","Trebuchet24", ScrW()/2,ScrW()/15,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,color_black)
    end)
end)
