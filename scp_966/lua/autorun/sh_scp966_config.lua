--Luctus SCP966 System
--Made by OverlordAkise

--Do you use the gDeathsystem or any other medic mod?
--If false players will sleep and can be killed with LMB
--If true players will die and can be finished off with LMB
LUCTUS_SCP966_GDEATHSYSTEM = false

--Walkspeed from which SCP966 can kill/sleep you
LUCTUS_SCP966_WALKSPEEDNEEDED = 80
--How much SCP966 heals by "finishing" sleeping / dieing players
LUCTUS_SCP966_HPGAINED = 100

--This can either be
-- The :GetName() string of the entity
-- The :MapCreationID() number of the entity
LUCTUS_SCP966_UNBREACHABLE = {
    ["blastdoor_457"] = true,
    ["blastdoor_457_1"] = true,
    ["457_door_l"] = true,
    ["457_door_r"] = true,
}

LUCTUS_SCP966_NV_JOBS = {
    ["MTF"] = true,
    ["Gun Dealer"] = true,
    ["Citizen"] = true,
    ["SCP 966"] = true,
}

print("[SCP966] config Loaded!")
