--Luctus SCP106
--Made by OverlordAkise


--Positions that SCP106 can teleport to (+ his old position before his TP)
--Use "cl_getpos" ingame to get the position of where you are standing
LUCTUS_SCP106_TP_POINTS = {
    ["Boilerroom"] = Vector(1890,2305,-3434),
}

--Entities the SCP106 can walk through
LUCTUS_SCP106_WALKABLE_ENTS = {
    ["func_door"] = true,
    ["prop_physics"] = true,
    ["prop_dynamic"] = true,
    ["prop_static"] = true,
    ["prop_door_rotating"] = true,
    ["prop_vehicle_jeep"] = true,
}
--Exceptions which entities SCP106 can NOT walk through
--These are the :MapCreationID of the entities
LUCTUS_SCP106_WALKABLE_EXCEPTIONS = {
    [1942] = true,
}
--Which models should SCP106 not be able to walk through
LUCTUS_SCP106_UNWALKABLE_MODELS = {
    ["models/props_c17/concrete_barrier001a.mdl"] = true,
}

--Speed of going into the ground when teleporting
LUCTUS_SCP106_TP_SPEED = 0.5
--Cooldown of teleporting self
LUCTUS_SCP106_TELEPORT_COOLDOWN = 10
--Delay of leftclick orbs
LUCTUS_SCP106_ATTACK_DELAY = 10
--Chargetime of leftclick orbs
LUCTUS_SCP106_ATTACK_CHARGETIME = 1
--Speed of the leftclick orb
LUCTUS_SCP106_ATTACK_FLYSPEED = 500

--Delay of rightclick teleporters
LUCTUS_SCP106_ALTATTACK_COOLDOWN = 5

--Sound of any teleportation (self&others)
LUCTUS_SCP106_TP_SOUND = "ambient/creatures/town_moan1.wav"

--Which models are immune from teleportation from SCP106
LUCTUS_SCP106_IMMUNE_MODELS = {
    ["models/player/corpse1.mdl"] = true,
}
--Which jobs are immune from teleportation from SCP106
LUCTUS_SCP106_IMMUNE_JOBS = {
    ["Citizen"] = true,
}


print("[SCP106] config loaded")
