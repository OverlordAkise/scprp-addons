--Luctus SCP939
--Made by OverlordAkise

--How much damage left click should do
LUCTUS_SCP939_DAMAGE = 30
--How many seconds between attacks
LUCTUS_SCP939_ATTACKDELAY = 0.5
--How many seconds delay between screaming to see
LUCTUS_SCP939_SCREAM_BRIGHT_DELAY = 30
--How long should it be bright for?
LUCTUS_SCP939_SCREAM_BRIGHT_DURATION = 3
--How fast should a player move to be seen by SCP939?
LUCTUS_SCP939_DETECT_SPEED = 70

--Special Attack with Right Mouse
--How many seconds between sniffing out nearby players
LUCTUS_SCP939_SCREAM_SEARCH_DELAY = 120
--How long should these special-ability-found players be highlighted for
LUCTUS_SCP939_SCREAM_SEARCH_DURATION = 5
--How far away should players max be found?
LUCTUS_SCP939_SCREAM_SEARCH_DISTANCE = 2048

--Doors which SCP939 can't open with leftclick
--This can either be
-- The :GetName() string of the entity
-- The :MapCreationID() number of the entity
LUCTUS_SCP939_UNBREACHABLE = {
    [3052] = true,
    ["173_containment_door_r"] = true,
}

print("[scp939] config loaded")
