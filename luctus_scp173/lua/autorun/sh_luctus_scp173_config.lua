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
--Weapon delay between left mouse (kill, open door)
SCP173_PRIMARY_DELAY = 0.2
--Weapon delay between right mouse (force-blink everyone near you)
SCP173_SECONDARY_DELAY = 3
--Force-Blink sound
SCP173_SECONDARY_SOUND = "HL1/fvox/buzz.wav"
--How long do people force-blink for, in seconds
SCP173_SECONDARY_BLINKTIME = 0.75

--This can either be
-- The :GetName() string of the entity
-- The :MapCreationID() number of the entity
SCP173_UNBREACHABLE = {
    ["173_containment_door_l"] = true,
    ["173_containment_door_r"] = true,
}

print("[scp173] config loaded")
