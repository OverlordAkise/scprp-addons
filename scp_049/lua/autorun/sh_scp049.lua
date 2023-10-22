--Luctus SCP049 System
--Made by OverlordAkise

SCP049_ZOMBIE_MODEL = "models/player/zombie_classic.mdl"

--Which models should be save from being killed by SCP049
SCP049_SAVE_PMODELS = {
    ["models/player/monk.mdl"] = true,
    [SCP049_ZOMBIE_MODEL] = true,
}

--Which doors SCP049 shouldnt be able to open
SCP049_UNBREACHABLE = {
    ["049_door_new"] = true,
    ["049_containment_door_r"] = true,
    ["049_containment_door_l"] = true,
}

print("[SCP049] config loaded")
