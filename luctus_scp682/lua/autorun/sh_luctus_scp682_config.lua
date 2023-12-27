--Luctus SCP682
--Made by OverlordAkise

--Regenerate X HP every second
LUCTUS_SCP682_REGENERATION = 3
--Should regeneration be stopped if being shot at
LUCTUS_SCP682_REGEN_DAMAGESTOP = true
--How long should regeneration be stopped for after being shot
LUCTUS_SCP682_REGEN_DAMGESTOP_DURATION = 5
--Should SCP682 be immune to the last weapon that damaged it?
--This makes SCP682 way more tanky, set its HP lower for this
LUCTUS_SCP682_IMMUNITY_SYSTEM_ACTIVE = true
--Start / Max model scale of SCP682
LUCTUS_SCP682_MAX_MODELSCALE = 2
--Min model scale
LUCTUS_SCP682_MIN_MODELSCALE = 0.5
--Handcuffable from what modelscale?
LUCTUS_SCP682_HANDCUFF_SCALE_NEEDED = 0.8

--Cooldown for R (reload) jump with SCP682
LUCTUS_SCP682_SPECIAL_JUMP_DELAY = 3
--How "fast" (strong) does SCP682 jump
LUCTUS_SCP682_SPECIAL_JUMP_STRENGTH = 500


--How much damage left click should do
LUCTUS_SCP682_DAMAGE = 3000
--How many seconds between attacks
LUCTUS_SCP682_ATTACKDELAY = 1

--Which doors should SCP682 not be able to breach?
LUCTUS_SCP682_UNBREACHABLE = {
    [4293] = true,
    ["lcz_maindoor_1"] = true,
}


print("[scp682] config loaded")
