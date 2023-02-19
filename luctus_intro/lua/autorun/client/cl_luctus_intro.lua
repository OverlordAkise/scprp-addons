--Luctus Intro
--Made by OverlordAkise

hook.Add("InitPostEntity", "luctus_intro_start", function()
    timer.Simple(3,function()
        net.Start("luctus_intro_start")
        net.SendToServer()
    end)
end)

net.Receive("luctus_intro_start",function()
    local ent = net.ReadEntity(luctusIntroEnt)
    if not IsValid(ent) then return end
    ent:SetNoDraw(true)
end)

print("[luctus_intro] cl loaded!")
