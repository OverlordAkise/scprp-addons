--Luctus SCP173 System
--Made by OverlordAkise

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

--currently random metal stress
SWEP.Sound = "physics/wood/wood_box_impact_hard3.wav" 

SWEP.KillSound = "npc/barnacle/neck_snap2.wav"

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

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextSecondaryFire(CurTime() + 1)
    if CLIENT then return end
    local ply = self:GetOwner()
    if not IsValid(ply) then return end
    local trace = ply:GetEyeTrace()
    local ent = trace.Entity
    if not IsValid(ent) then return end
    if not ent:isDoor() then return end
    if ply:EyePos():Distance(trace.HitPos) > 512 then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if SCP173_UNBREACHABLE[trace.Entity:GetName()] or SCP173_UNBREACHABLE[trace.Entity:MapCreationID()] then
        DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
        return false
    end
    
    --SCP doors:
    if ent:GetClass() == "prop_dynamic" and ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
        ent = ent:GetParent()
    end
    ent:keysUnLock()
    ent:Fire("open", "", .6)
    ent:Fire("setanimation", "open", .6)
    
    hook.Run("onDoorRamUsed", true, ply, trace)
    --ply:EmitSound(self.Sound)
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav")
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    local owner = self:GetOwner()
    local tr = owner:GetEyeTrace()
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > 256 then return end
    -- effect
    if hitEnt:IsPlayer() then
        local edata = EffectData()
        edata:SetStart(owner:GetShootPos())
        edata:SetOrigin(tr.HitPos)
        edata:SetNormal(tr.Normal)
        edata:SetEntity(hitEnt)
        util.Effect("BloodImpact", edata)
        if SERVER then
            hitEnt:TakeDamage(99997, owner, self)
            owner:EmitSound(self.KillSound)
        end
    end
    self:SetNextPrimaryFire(CurTime() + 0.2)
end
