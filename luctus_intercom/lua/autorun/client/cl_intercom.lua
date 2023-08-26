--Luctus Intercom
--Made by OverlordAkise

INTERCOM_IS_TALKING = false

net.Receive("luctus_intercom_sync",function()
    local isLive = net.ReadBool()
    INTERCOM_IS_TALKING = isLive
    if isLive then
        notification.AddLegacy("[intercom] You are now live!",2,3)
        surface.PlaySound("buttons/button17.wav")
    else
        notification.AddLegacy("[intercom] Others can't hear you anymore!",2,3)
        surface.PlaySound("buttons/button18.wav")
    end
end)

print("[luctus_intercom] cl loaded!")
