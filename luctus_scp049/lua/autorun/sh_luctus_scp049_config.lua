--Luctus SCP049 System
--Made by OverlordAkise

--Should the "Mix-Table" be printed to serverconsole if it refreshes?
LUCTUS_SCP049_PRINT_MIXTABLE = true
--Should the Mix-Table be changed whenever a new player becomes SCP049?
LUCTUS_SCP049_REMIX_ON_PLY_CHANGE = true
--Model for revived players from scp049 (= scp049-2 model)
LUCTUS_SCP049_ZOMBIE_MODEL = "models/player/zombie_classic.mdl"
--Which models should be save from being killed by SCP049
LUCTUS_SCP049_SAVE_PMODELS = {
    ["models/player/monk.mdl"] = true,
    [LUCTUS_SCP049_ZOMBIE_MODEL] = true,
}
--Which doors SCP049 shouldnt be able to open
LUCTUS_SCP049_UNBREACHABLE = {
    ["049_door_new"] = true,
    ["049_containment_door_r"] = true,
    ["049_containment_door_l"] = true,
}
--What should the things be that you can mix
LUCTUS_SCP049_MIX_INGREDIENTS = {
    {"red",Color(255,0,0)},
    {"green",Color(0,255,0)},
    {"blue",Color(0,0,255)},
    {"yellow",Color(255,215,0)},
    {"purple",Color(128,0,128)},
    {"cyan",Color(0,255,255)},
    {"grey",Color(211,211,211)},
}

print("[scp049] config loaded")
