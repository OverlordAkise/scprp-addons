--Luctus SCP173 System
--Made by OverlordAkise

--PrimaryAttack is made by the TTT developers of the knife
--SecondaryAttack is made by the DarkRP developer (FPTje)

AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
DEFINE_BASECLASS("weapon_cs_base2")

SWEP.PrintName = "SCP173 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Left click to kill, right click to break open doors"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP173"
SWEP.IsDarkRPDoorRam = true

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.AnimPrefix = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "SCP"

SWEP.Sound = "physics/wood/wood_box_impact_hard3.wav"
SWEP.KillSound = "player/pl_fallpain1.wav"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

-- Ram action when ramming a door
local function ramDoor(ply, trace, ent)
    if ply:EyePos():DistToSqr(trace.HitPos) > 10000 then return false end
    if CLIENT then return true end
    if ent:GetClass() == "prop_dynamic" then
        if ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
            ent = ent:GetParent()
        end
    end
    ent:keysUnLock()
    ent:Fire("open", "", .6)
    ent:Fire("setanimation", "open", .6)
    return true
end

-- Decides the behaviour of the ram function for the given entity
local function getRamFunction(ply, trace)
    local ent = trace.Entity
    if not IsValid(ent) then return false end
    if SERVER then
        if trace.Entity:GetName() == "173_containment_door_l" or trace.Entity:GetName() == "173_containment_door_r" then
            DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
            return false
        end
    end
    local override = hook.Call("canDoorRam", nil, ply, trace, ent)
    if override ~= nil then
        return override
    end
    if ent:isDoor() then    
        return ramDoor(ply, trace, ent)
    end
    return false
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    local Owner = self:GetOwner()
    if not IsValid(Owner) then return end
    
    self:SetNextSecondaryFire(CurTime() + 1)
    local trace = Owner:GetEyeTrace()
    local hasRammed = getRamFunction(Owner, trace)
    if SERVER then
        hook.Call("onDoorRamUsed", GAMEMODE, hasRammed, Owner, trace)
    end

    if not hasRammed then return end
    Owner:SetAnimation(PLAYER_ATTACK1)
    Owner:EmitSound(self.Sound)
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end

    self:GetOwner():LagCompensation(true)

    local spos = self:GetOwner():GetShootPos()
    local sdest = spos + (self:GetOwner():GetAimVector() * 70)

    local kmins = Vector(1,1,1) * -10
    local kmaxs = Vector(1,1,1) * 10

    local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

    -- Hull might hit environment stuff that line does not hit
    if not IsValid(tr.Entity) then
        tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
    end

    local hitEnt = tr.Entity

    -- effects
    if IsValid(hitEnt) then
        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

        local edata = EffectData()
        edata:SetStart(spos)
        edata:SetOrigin(tr.HitPos)
        edata:SetNormal(tr.Normal)
        edata:SetEntity(hitEnt)

        if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
            util.Effect("BloodImpact", edata)
        end
    else
        self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
    end

    if SERVER then
        self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
    end


    if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) and hitEnt:IsPlayer() then
        local dmg = DamageInfo()
        dmg:SetDamage(5000)
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self.Weapon or self)
        dmg:SetDamageForce(self:GetOwner():GetAimVector() * 5)
        dmg:SetDamagePosition(self:GetOwner():GetPos())
        dmg:SetDamageType(DMG_SLASH)

        hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
        self:GetOwner():EmitSound(self.KillSound)
    end
    self:GetOwner():LagCompensation(false)
end
