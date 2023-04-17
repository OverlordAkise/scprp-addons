--Luctus SCP457
--Made by OverlordAkise

AddCSLuaFile()

SWEP.PrintName = "SCP 457"
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "Set people aflame"
SWEP.Instructions = "Press LMB to shoot a firelaser!"
SWEP.Category = "SCP"
SWEP.Sound = "weapons/physcannon/energy_sing_explosion2.wav"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.HoldType = "normal"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Delay = 2
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "None"

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel() end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Holster()
    return true
end

function SWEP:CanPrimaryAttack()
    return false
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    local owner = self:GetOwner()
    self:SetNextPrimaryFire(CurTime()+LUCTUS_SCP457_IGNITE_ATTACK_DELAY)
    if SERVER and CurTime() < owner.lNoBurn then return end
    
    --Laser effect
    local effectdata = EffectData()
    effectdata:SetOrigin(owner:GetPos()+Vector(0,0,50))
    local tr = owner:GetEyeTrace()
    effectdata:SetNormal(tr.Normal)
    effectdata:SetRadius(30)
    util.Effect("AR2Explosion", effectdata)
    owner:EmitSound(self.Sound)
    
    if CLIENT then return end
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > LUCTUS_SCP457_IGNITE_ATTACK_RANGE then return end
    if not hitEnt:IsPlayer() then return end    
    hitEnt:Ignite(LUCTUS_SCP457_IGNITE_ATTACK_DURATION,LUCTUS_SCP457_IGNITE_ATTACK_BURN_RANGE)
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
    if ply:EyePos():Distance(trace.HitPos) > 128 then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if SCP457_UNBREACHABLE[trace.Entity:GetName()] or SCP457_UNBREACHABLE[trace.Entity:MapCreationID()] then
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
