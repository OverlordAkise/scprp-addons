--Luctus Weaponcabinet
--Made by OverlordAkise

--How many weapons you can retrieve in one life
LUCTUS_WEAPONCABINET_MAX = 3

--Should players keep weapons over respawn in same job?
LUCTUS_WEAPONCABINET_KEEPWEPS = true

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

--The weapons you can buy
LUCTUS_WEAPONNPC_WEAPONS = {
    ["Pistols"] = {
        AllowedJobs = {"Citizen","Gangster"},
        Weapons = {
            ["m9k_luger"] = 500,
            ["m9k_scoped_taurus"] = 500,
            ["m9k_coltpython"] = 500,
            ["m9k_remington1858"] = 500,
            ["m9k_model3russian"] = 500,
            ["m9k_model500"] = 500,
            ["m9k_model627"] = 500,
            ["m9k_sig_p229r"] = 700,
        },
    },
    ["Rifles"] = {
        AllowedJobs = {"Medic","Gangster"},
        Weapons = {
            ["m9k_acr"] = 1100,
            ["m9k_ak47"] = 1300,
        },
    },
}

print("[luctus_weaponcabinet] config loaded")
