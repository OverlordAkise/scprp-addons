--Luctus Medic (SCP)
--Made by OverlordAkise


LUCTUS_MEDIC_HITGROUPS = {
    [HITGROUP_HEAD] = "head",
    [HITGROUP_CHEST] = "chest",
    [HITGROUP_LEFTARM] = "arms",
    [HITGROUP_RIGHTARM] = "arms",
    [HITGROUP_LEFTLEG] = "legs",
    [HITGROUP_RIGHTLEG] = "legs",
}

local PLAYER = FindMetaTable("Player")

function PLAYER:IsBleeding()
    return self:GetBleeding() > 0
end

function PLAYER:GetBleeding()
    return self:GetNW2Int("Bleeding", 0)
end

function PLAYER:AddBleeding(f)
    self:SetNW2Int("Bleeding", math.Clamp(self:GetBleeding() + f, 0, 100))
end

function PLAYER:ResetMedicState()
    self:SetNW2Int("head",100)
    self:SetNW2Int("arms",100)
    self:SetNW2Int("chest",100)
    self:SetNW2Int("legs",100)
end

hook.Add("EntityFireBullets","luctus_smedic_hurt_hands",function(ent, data)
    if not ent:IsPlayer() then return end
    if not LUCTUS_MEDIC_DAMAGE_ENABLED then return end
    if not IsFirstTimePredicted() then return end
    local power = 1 - (ent:GetNW2Int("arms",100) / 100)
    local randomSeedX = util.SharedRandom( "BulletRandomX", power, power, CurTime() ) * LUCTUS_MEDIC_DAMAGE_ARMS
    local randomSeedY = util.SharedRandom( "BulletRandomY", power, power, CurTime() ) * LUCTUS_MEDIC_DAMAGE_ARMS
    data.Spread = Vector(randomSeedX, randomSeedY, 0) / 4
    return true
end)

hook.Add("Move","luctus_smedic_hurt_legs",function(ply, mv)
    if not LUCTUS_MEDIC_DAMAGE_ENABLED then return end
    if ply:GetNW2Int("legs",100) < 100 and !ply:InVehicle() and ply:IsOnGround() then
        local percent = (1 - LUCTUS_MEDIC_DAMAGE_LEGS) + (ply:GetNW2Int("legs",100) / 100) * LUCTUS_MEDIC_DAMAGE_LEGS
        mv:SetMaxSpeed(mv:GetMaxSpeed() * math.max(0.2, percent))
        mv:SetMaxClientSpeed(mv:GetMaxSpeed() * math.max(0.2, percent))
    end
end)

print("[luctus_smedic] sh meta loaded")
