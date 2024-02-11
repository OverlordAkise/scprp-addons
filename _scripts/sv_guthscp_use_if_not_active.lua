--Luctus GuthSCP Keycard Easy Use
--Made by OverlordAkise

--This script allows you to "use" GuthSCP's Keycards on doors without having them in your hand
--This means it is enough to have the keycards in your possession to use them on doors
--Change the below table to allow other keycards to be recognized
local weaponLevels = {
    ["guthscp_keycard_lvl_1"] = 1,
    ["guthscp_keycard_lvl_2"] = 2,
    ["guthscp_keycard_lvl_3"] = 3,
    ["guthscp_keycard_lvl_4"] = 4,
    ["guthscp_keycard_lvl_5"] = 5,
    ["guthscp_keycard_lvl_omni"] = 6,
}

--End of config

function PlayerHasKeycardMinLevel(ply,levelNeeded)
    for k,wep in ipairs(ply:GetWeapons()) do
        local lvl = weaponLevels[wep:GetClass()]
        if lvl and lvl >= levelNeeded then return true end
    end
    return false
end

--Copied from GuthSCP:PlayerUse (sv_guthscp_keycard.lua)
function LuctusGuthSCPInvUse(ply, ent)
    if not IsValid(ent) or not IsValid(ply) then return end
    if not GuthSCP.keycardAvailableClass[ent:GetClass()] then return end
    local ent_level = ent:GetNWInt("GuthSCP:LVL", -1)
    if ent_level <= -1 then return end
    if ply.guthscp_last_use_time and ply.guthscp_last_use_time > CurTime() then return false end
    
    local weapon = ply:GetActiveWeapon()
    --NEW: Check if keycard in possession
    if not IsValid(weapon) or not weapon.GuthSCPLVL then
        if PlayerHasKeycardMinLevel(ply,ent_level) then
            ply:EmitSound( "guthen_scp/interact/KeycardUse1.ogg" )
            ply:setBottomMessage( "The doors are moving !" )
            return
        end
        ply:EmitSound( "guthen_scp/interact/KeycardUse2.ogg" )
        ply:setBottomMessage( "You don't have any keycard to pass !" )
        return false
    end
    local ply_level = weapon.GuthSCPLVL
    ply.guthscp_last_use_time = CurTime() + GuthSCP.useCooldown
    if weapon.Base == "guthscp_keycard_base" then
	    weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    end
    if not ply_level then
        ply:EmitSound( "guthen_scp/interact/KeycardUse2.ogg" )
        ply:setBottomMessage( "You don't have any keycard to pass !" )
        return false
    elseif ply_level < ent_level then
        ply:EmitSound( "guthen_scp/interact/KeycardUse2.ogg" )
        ply:setBottomMessage( "You need a keycard LVL " .. ent_level .. " to trigger the doors !" )
        return false
    end
    ply:EmitSound( "guthen_scp/interact/KeycardUse1.ogg" )
    ply:setBottomMessage( "The doors are moving !" )
    return true
end

--overwrite it later after the guthscp addon loaded
hook.Add("PlayerInitialSpawn","luctus_guthscp_inv_overwrite",function()
    hook.Add("PlayerUse","GuthSCP:PlayerUse",LuctusGuthSCPInvUse)
    print("[luctus_guthscp_use] GuthSCP:PlayerUse successfully overwritten")
    hook.Remove("PlayerInitialSpawn","luctus_guthscp_inv_overwrite")
end)

print("[luctus_guthscp_use] sv loaded")
