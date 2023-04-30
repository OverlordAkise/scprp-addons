--Luctus SCP Radio
--Made by OverlordAkise

hook.Add("InitPostEntity","luctus_sradio_config",function()

--CONFIG START

LUCTUS_RADIO_CHANNELS = {
    ["MTF"] = {TEAM_MTF,TEAM_MTF2},
    ["Civilians"] = {TEAM_CITIZEN, TEAM_MEDIC},
    ["Hobos"] = {TEAM_HOBO},
    ["All"] = {TEAM_CITIZEN,TEAM_HOBO,TEAM_BLOBEL},
}

--CONFIG END

print("[luctus_sradio] config loaded!")
end)
print("[luctus_sradio] sh loaded!")
