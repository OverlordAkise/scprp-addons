--Luctus Intercom
--Made by OverlordAkise

--CONFIG START

--Is the Intercom start and stop sound a URL or a gmod sound?
LUCTUS_INTERCOM_IS_URL = false

--The sound to play when someone is starting to speak on the intercom
LUCTUS_INTERCOM_SOUND_START = "npc/overwatch/radiovoice/on1.wav"

--The sound to play when no one is using an intercom anymore
LUCTUS_INTERCOM_SOUND_STOP = "npc/overwatch/radiovoice/off4.wav"


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
net.Receive("luctus_intercom_sound",function()
    local isStarting = net.ReadBool()
    local toplay = LUCTUS_INTERCOM_SOUND_START
    if not isStarting then
        toplay = LUCTUS_INTERCOM_SOUND_STOP
    end
    if not LUCTUS_INTERCOM_IS_URL then
        surface.PlaySound(toplay)
    else
        sound.PlayURL(toplay,"",function(station,errid,errname)
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
