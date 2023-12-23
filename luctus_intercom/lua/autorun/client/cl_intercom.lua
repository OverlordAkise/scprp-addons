--Luctus Intercom
--Made by OverlordAkise

--CONFIG START

--Is the Intercom start sound a URL or a gmod sound?
LUCTUS_INTERCOM_IS_URL = false

--The sound to play when someone is starting to speak on the intercom
LUCTUS_INTERCOM_SOUND = "npc/overwatch/radiovoice/attention.wav"


--CONFIG END

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

local g_station = nil
net.Receive("luctus_intercom_startsound",function()
    if not LUCTUS_INTERCOM_IS_URL then
        surface.PlaySound(LUCTUS_INTERCOM_SOUND)
    else
        sound.PlayURL(LUCTUS_INTERCOM_SOUND,"",function(station,errid,errname)
            if IsValid(station) then
                station:Play()
                g_station = station
            else
                print("ERROR playing URL for intercom!",errid,errname)
            end
        end)
    end
end)

print("[luctus_intercom] cl loaded!")
