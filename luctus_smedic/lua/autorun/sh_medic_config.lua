--Luctus Medic (SCP)
--Made by OverlordAkise

--Time you are bleeding out for
--During this time you are "down"
--You can be shot to be killed or revived with a defib
--You will respawn after this time if you are still down
LUCTUS_MEDIC_BLEEDOUT_TIME = 60
--Should job change be allowed if ply is dead
LUCTUS_MEDIC_DEAD_CAN_CHANGE_TEAM = true
--How much time stabilization should add, in seconds
LUCTUS_MEDIC_STABILIZE_TIME_ADDED = 30


--How much limb/chest damage your bandages heal
LUCTUS_MEDIC_BANDAGE_HEAL_LIMBS = 30
--How much bleeding the bandage stops
LUCTUS_MEDIC_BANDAGE_HEAL_BLEED = 30
--How much health a bandage heals
LUCTUS_MEDIC_BANDAGE_HEAL_HP = 30
--These teams can neither bleed nor be revived
LUCTUS_MEDIC_IMMUNE_TEAMS = {
    ["Hobo"] = true,
}

--//Killing bleeding out corpses
--Enable it
LUCTUS_MEDIC_RAGDOLL_KILLABLE = true
--Time until respawn after getting killed while downed
LUCTUS_MEDIC_RESPAWN_TIME = 30
--Health the ragdoll has
LUCTUS_MEDIC_RAGDOLL_HEALTH = 100


--Bleeding:
--  Bleeding builds up from damage, 0->100
--  Every second you have a chance to bleed
--  The higher your bleed buildup the higher the chance to take damage every second
--  Everytime you successfully bleed you will loose 1 buildup bleeding
--Is enabled
LUCTUS_MEDIC_BLEEDING_ENABLED = true
--Chance to bleed with every bullet hit
--To disable bleeding set this to -1
LUCTUS_MEDIC_BLEED_CHANCE = 50
--Damage you take every bleed hit
LUCTUS_MEDIC_BLEED_DAMAGE = 1
--How much percentage of the damage should be bleeding? (if bleed procs)
LUCTUS_MEDIC_BLEEDING_RATIO = 0.5
--Enable UI if bleeding
LUCTUS_MEDIC_BLEEDING_SCREEN = true

--Client messages on deathscreen
LUCTUS_MEDIC_DEATHSCREEN_BLEEDING_HEADER = "You are bleeding out!"
LUCTUS_MEDIC_DEATHSCREEN_BLEEDING_BODY = "You better wait for a medic to revive you!"
LUCTUS_MEDIC_DEATHSCREEN_DEAD_HEADER = "You are dead!"
LUCTUS_MEDIC_DEATHSCREEN_DEAD_BODY = "Wait until you can respawn!"

--//Limb Damage System
--Should enable limb damage
LUCTUS_MEDIC_DAMAGE_ENABLED = true
--How much your head hurts (vision blur)
LUCTUS_MEDIC_DAMAGE_HEAD = 0.8
--How much your arms hurt (aim shake)
LUCTUS_MEDIC_DAMAGE_ARMS = 1
--How much your legs hurt (movement slow)
LUCTUS_MEDIC_DAMAGE_LEGS = 0.6
--How much your chest hurt (damage scaling)
LUCTUS_MEDIC_DAMAGE_CHEST = 0.5

--How much money it costs to be revived, set to 0 to disable
LUCTUS_MEDIC_REVIVE_COST = 100

--Should damage be multiplied if hit in a specific region of the body
LUCTUS_MEDIC_CUSTOM_DAMAGE_SCALING = true
--By how much do we multiply damage if hit in region X
--e.g. head = 2 means headshots do 2x damage
LUCTUS_MEDIC_CUSTOM_DAMAGE_SCALE = {
    [HITGROUP_GENERIC] = 1, --Default
    [HITGROUP_HEAD] = 2,
    [HITGROUP_CHEST] = 0.7,
    [HITGROUP_STOMACH] = 0.6,
    [HITGROUP_LEFTARM] = 0.5,
    [HITGROUP_RIGHTARM] = 0.5,
    [HITGROUP_LEFTLEG] = 0.5,
    [HITGROUP_RIGHTLEG] = 0.5,
    [HITGROUP_GEAR] = 0.25, --Belt
}

print("[luctus_smedic] config loaded")
