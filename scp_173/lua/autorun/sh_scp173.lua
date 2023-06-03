--Luctus SCP173 System
--Made by OverlordAkise

--For the cage to work you need the following workshop item:
--https://steamcommunity.com/sharedfiles/filedetails/?id=951301796

--Every X seconds you blink
SCP173_BLINK_INTERVAL = 5
--How long you blink for in seconds
SCP173_BLINK_DURATION = 0.2
--How close you have to be to 173 to start blinking
SCP173_BLINK_RANGE = 2000*2000

--This can either be
-- The :GetName() string of the entity
-- The :MapCreationID() number of the entity
SCP173_UNBREACHABLE = {
    ["173_containment_door_l"] = true,
    ["173_containment_door_r"] = true,
}

print("[SCP173] config Loaded!")
