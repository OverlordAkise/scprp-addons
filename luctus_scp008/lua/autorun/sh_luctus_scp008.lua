--Luctus SCP008 System
--Made by OverlordAkise

--Set this to false after perma-prop'ing the cubes in the correct place
--to make the SCP008 entities invisible
LUCTUS_SCP008_DEBUG = false

--Which playermodels should be immune to SCP008 infection
LUCTUS_SCP008_IMMUNEMODELS = {
    ["models/player/group01/female_01.mdl"] = true,
}

--Infection stuff
--Your infection level raises from 0 to 100
--If it reaches 100 you will become a SCP008 zombie

--Every X seconds your infection gets worse
LUCTUS_SCP008_INFECTION_TIME = 10

--How much your infection worsens every above seconds
LUCTUS_SCP008_INFECTION_WORSENING = 2

--How much infection you should get by being hit by weapon_scp008
LUCTUS_SCP008_INFECTION_RAISEDBYHIT = 2

--How much you get while exposed to SCP008 (value adds 10times per second)
LUCTUS_SCP008_DIRECT_EXPOSURE = 0.2

--Current standard config:
--2 per second while exposed to SCP008
--2 every 10s while not exposed but infected
--If hit by SCP008 Zombie once it takes 8minutes to become one too

print("[SCP008] SH Loaded!")
