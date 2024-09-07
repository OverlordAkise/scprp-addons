--Luctus SCP008 System
--Made by OverlordAkise

AddCSLuaFile()

SWEP.PrintName = "SCP008 Medkit"
SWEP.Author = "Kilburn, robotboy655, MaxOfS2D & Tenrys"
SWEP.Purpose = "LMB = Heal, RMB = Analyse"
SWEP.Category = "SCP"

SWEP.Primary.Damage = 20
SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip  = -1
SWEP.Primary.Automatic    = false
SWEP.Primary.Ammo      = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic  = false
SWEP.Secondary.Ammo      = "none"

SWEP.Slot = 4
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.SoundHeal = "HL1/fvox/antidote_shot.wav"
SWEP.SoundNothing = "items/medshotno1.wav"
SWEP.SoundInfectedLow = "HL1/fvox/bio_reading.wav"
SWEP.SoundInfectedHigh = "HL1/fvox/biohazard_detected.wav"
SWEP.SoundTooLate = "HL1/fvox/innsuficient_medical.wav"

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
	local startpos = owner:GetShootPos()
	local tr = util.TraceLine({
		start = startpos,
		endpos = startpos + owner:GetAimVector() * 75,
		filter = owner
	})
    local ply = tr.Entity
    -- local ply = Entity(1)
    if not IsValid(ply) then return end
    
    local inf = ply:GetNW2Float("luctus_scp008_infection",0)
    if ply:GetNW2Bool("scp008_zombie",false) or inf <= 0 or inf >= 80 then
        if CLIENT then surface.PlaySound(self.SoundNothing) end
        self:SetNextPrimaryFire(CurTime()+1)
        return
    end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:SetAnimation(PLAYER_ATTACK1)

	local endtime = CurTime() + self:SequenceDuration()
	self:SetNextPrimaryFire(endtime)
	self:SetNextSecondaryFire(endtime)
    
    self:EmitSound(self.SoundHeal)
    if CLIENT then return end
    LuctusSCP008StopInfection(ply)
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
	local startpos = owner:GetShootPos()
	local tr = util.TraceLine({
		start = startpos,
		endpos = startpos + owner:GetAimVector() * 75,
		filter = owner
	})
    local ply = tr.Entity
    -- local ply = Entity(1)
    if not IsValid(ply) then return end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:SetAnimation(PLAYER_ATTACK1)

	local endtime = CurTime() + self:SequenceDuration()
	self:SetNextPrimaryFire(endtime)
	self:SetNextSecondaryFire(endtime)
    
    if SERVER then return end
    
    local inf = ply:GetNW2Float("luctus_scp008_infection",0)
    if ply:GetNW2Bool("scp008_zombie",false) then
        surface.PlaySound(self.SoundTooLate)
    elseif inf <= 0 then
        surface.PlaySound(self.SoundNothing)
    elseif inf < 33 then
        surface.PlaySound(self.SoundInfectedLow)
    elseif inf < 80 then
        surface.PlaySound(self.SoundInfectedHigh)
    elseif inf >= 80 then
        surface.PlaySound(self.SoundTooLate)
    end
end

