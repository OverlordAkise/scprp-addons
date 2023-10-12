--Luctus SCP096 System
--Made by OverlordAkise

--If you use gDeathSystem please enable this
LUCTUS_SCP096_GDEATHSYSTEM = true

--Which jobs should NOT trigger 096
LUCTUS_SCP096_IMMUNE_JOBS = {
    ["KR Unit"] = true,
    ["Hobo"] = true,
}

--This can either be
-- The :GetName() string of the entity
-- The :MapCreationID() number of the entity
SCP096_UNBREACHABLE = {
    ["hcz_door_2_30"] = true,
}

print("[SCP096] config loaded!")
