--Luctus SCP Radio
--Made by OverlordAkise

hook.Add("InitPostEntity","luctus_sradio_config",function()

--CONFIG START

--Should you switch channels quickly with R directly or open a menu to choose your channel?
LUCTUS_RADIO_INSTASWITCH = true

--What jobs can speak in what channel
LUCTUS_RADIO_CHANNELS = {
  --[ChannelName] = {List,Of,Jobs},
    ["MTF"] = {TEAM_MTF,TEAM_MTF2},
    ["Civilians"] = {TEAM_CITIZEN, TEAM_MEDIC},
    ["Hobos"] = {TEAM_HOBO},
    ["All"] = {TEAM_CITIZEN,TEAM_HOBO,TEAM_BLOBEL},
}

--CONFIG END

LUCTUS_RADIO_CHANNELS["Emergency"] = {} --dont delete this

print("[luctus_sradio] config loaded")
end)
print("[luctus_sradio] sh loaded")
