--Luctus Hazmat
--Made by OverlordAkise

LUCTUS_HAZMAT_MODELS = {
    ["models/player/group01/female_01.mdl"] = true, --testing
    ["models/hazmat.mdl"] = true,
}

LUCTUS_HAZMAT_DMGTYPES = {
    [DMG_BURN] = true,
    [DMG_BLAST] = true, --m9k nerve gas
    [DMG_SHOCK] = true,
    [DMG_SONIC] = true,
    [DMG_ENERGYBEAM] = true,
    [DMG_PARALYZE] = true,
    [DMG_NERVEGAS] = true,
    [DMG_POISON] = true,
    [DMG_RADIATION] = true,
    [DMG_ACID] = true,
    [DMG_SLOWBURN] = true,
    [DMG_PLASMA] = true,
}

LUCTUS_HAZMAT_WEAPONS = {
    ["m9k_released_poison"] = true, --m9k nerve gas explosion
    ["weapon_scp049"] = true,
}

hook.Add("EntityTakeDamage","luctus_hazmat",function(ply,dmg)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or not LUCTUS_HAZMAT_MODELS[ply:GetModel()] then return end
    if LUCTUS_HAZMAT_DMGTYPES[dmg:GetDamageType()] then return true end
    if LUCTUS_HAZMAT_WEAPONS[dmg:GetInflictor():GetClass()] then return true end
end)

--[[
--Debug
hook.Add("EntityTakeDamage","luctus_debughazmat",function(ply,dmg)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
    print("[DEBUG] -----EntityTakeDamage-----")
    print("[DEBUG] Player:",ply)
    print("[DEBUG] Model:",ply:GetModel())
    print("[DEBUG] DamageType:",dmg:GetDamageType())
    print("[DEBUG] Attacker:",dmg:GetInflictor())
    print("[DEBUG] IsModelSave:",LUCTUS_HAZMAT_MODELS[ply:GetModel()])
    print("[DEBUG] IsDamageTypeSave:",LUCTUS_HAZMAT_DMGTYPES[dmg:GetDamageType()])
    print("[DEBUG] IsAttackerSave:",LUCTUS_HAZMAT_WEAPONS[dmg:GetInflictor():GetClass()])
end)
--]]

print("[luctus_hazmat] sv loaded!")
