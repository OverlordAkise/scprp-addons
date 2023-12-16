--Luctus SCP457 System
--Made by OverlordAkise

--Be this close to 049 to be ignited automatically
LUCTUS_SCP457_IGNITE_RADIUS = 128
--How long should you get ignited if you get too close
LUCTUS_SCP457_IGNITE_DURATION = 1
--How long should 049 be extinguished if spray him
LUCTUS_SCP457_EXTINGUISH_DURATION = 3

--Range of firelaser
LUCTUS_SCP457_IGNITE_ATTACK_RANGE = 512
--How long a firelaser should ignite people for
LUCTUS_SCP457_IGNITE_ATTACK_DURATION = 10
--Range of ignition near the firelaser target
LUCTUS_SCP457_IGNITE_ATTACK_BURN_RANGE = 512
--Delay of firelasers
LUCTUS_SCP457_IGNITE_ATTACK_DELAY = 60
--Which doors should SCP457 not be able to open with RMB
LUCTUS_SCP457_UNBREACHABLE = {
    ["blastdoor_tru4571"] = true,
    ["blastdoor_tru4572"] = true,
    ["lcz_door_2_25"] = true,
}
--Which models are immune to burning from being near SCP457
LUCTUS_SCP457_IMMUNE_MODELS = {
    ["models/player/corpse1.mdl"] = true,
}
--Which jobs are immune to burning from being near SCP457
LUCTUS_SCP457_IMMUNE_JOBS = {
    ["Citizen"] = true,
}


print("[SCP457] config loaded")
