--Luctus Weaponarmory
--Made by OverlordAkise


--Don't give ammo when taking out a weapon?
--Warning: If false this could give a player infinite ammo
LUCTUS_WEAPONARMORY_NOAMMO = true

--Color for UI borders
LUCTUS_WEAPONARMORY_ACCENT_COLOR = Color(0, 195, 165)

LUCTUS_WEAPONARMORY = {
    ["Pistols"] = {
        AllowedJobs = {
            ["Citizen"] = true,
            ["Gangster"] = true,
        },
        MaxAllowed = 1,
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
        AllowedJobs = {
            ["Medic"] = true,
            ["Gangster"] = true,
        },
        MaxAllowed = 2,
        Weapons = {
            ["m9k_acr"] = 1100,
            ["m9k_ak47"] = 1300,
            ["m9k_ak74"] = 1300,
            ["m9k_m16a1"] = 1300,
        },
    },
}

print("[luctus_weaponarmory] config loaded")
