--Luctus Amnestics
--Made by OverlordAkise

AddCSLuaFile()

SWEP.myclass = "weapon_amnestic"
SWEP.mytype = "A"
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.PrintName = "Amnestic A"
SWEP.Slot = 5
SWEP.SlotPos = 2

SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false 


SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Amnestics"

SWEP.ViewModel = "models/weapons/darky_m/c_syringe_v2.mdl"
SWEP.WorldModel = "models/weapons/darky_m/w_syringe_v2.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Syringes"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:SecondaryAttack()
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    local target = self:CheckTrace()

    if not IsValid(target) or (not target:IsPlayer() and not target:IsNPC()) then return end
    self:SetNextPrimaryFire(CurTime()+2.7)
    owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)
    owner:EmitSound(LUCTUS_AMNESTICS_SYRINGE_SOUND)
    
    if CLIENT then return end
    LuctusSendAmnesticsEffect(owner,target,self.mytype)
    
    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    timer.Simple(2.7,function()
        if not IsValid(self) or not IsValid(owner) then return end
        
        if LUCTUS_AMNESTICS_ONETIMEUSE then
            owner:StripWeapon(self.myclass)
            return
        end
        self:TakePrimaryAmmo(1)
        if self:Ammo1() <= 0 then
            owner:StripWeapon(self.myclass)
        end
        self:SendWeaponAnim(ACT_VM_IDLE)
    end)
end

function SWEP:CheckTrace()
    local owner = self:GetOwner()
    owner:LagCompensation(true)
    local Trace = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * 64,
        filter = owner
    })
    owner:LagCompensation(false)
    return Trace.Entity
end
