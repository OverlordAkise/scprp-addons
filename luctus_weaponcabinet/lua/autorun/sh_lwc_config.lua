--Luctus Weaponcabinet
--Made by OverlordAkise

--How many weapons you can retrieve in one life
LUCTUS_WEAPONCABINET_MAX = 3

--The weapons and which job can retrieve them
LUCTUS_WEAPONCABINET = {
    ["Big Guns"] = {
        {"Citizen","Gangster"},
        {"m9k_acr","weapon_ak472","m9k_minigun","csgo_bayonet_autotronic","weapon_deagle2","weapon_fiveseven2","m9k_coltpython","m9k_m92beretta","m9k_luger","m9k_ragingbull","m9k_scoped_taurus","m9k_remington1858","m9k_model3russian","m9k_model500","m9k_model627","m9k_sig_p229r","m9k_m3","m9k_browningauto5","m9k_dbarrel","m9k_ithacam37","m9k_mossberg590"},
    },
    ["Small Guns"] = {
        {"Citizen (Rekrut)","Citizen"},
        {"m9k_winchester73","m9k_ak47"},
    },
}

--CONFIG END


LUCTUS_WEAPONCABINET_S = {} --create beautified lookup table here
for cat,info in pairs(LUCTUS_WEAPONCABINET) do
    LUCTUS_WEAPONCABINET_S[cat] = {}
    LUCTUS_WEAPONCABINET_S[cat]["jobs"] = {}
    LUCTUS_WEAPONCABINET_S[cat]["weps"] = {}
    for _,job in pairs(info[1]) do
        LUCTUS_WEAPONCABINET_S[cat]["jobs"][job] = true
    end
    for _,wep in pairs(info[2]) do
        LUCTUS_WEAPONCABINET_S[cat]["weps"][wep] = true
    end
end

print("[luctus_weaponcabinet] config loaded")
