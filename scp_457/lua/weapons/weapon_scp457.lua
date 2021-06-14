AddCSLuaFile()
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
SWEP.Author = "DjBuRnOuT and BT"
SWEP.Purpose = "Kill people"
SWEP.Instructions = "Fire near enemies"
SWEP.Category = "SCP"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.PrintName = "SCP 457"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.HoldType = "normal"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.ISSCP = true
SWEP.droppable = false
SWEP.NextAttackW = 0

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Holster()
    return true
end

function SWEP:CanPrimaryAttack()
    return false
end

function SWEP:Think()
	if SERVER then
    if not self.Owner.lNoBurn then
      self.Owner.lNoBurn = 0
    end
    if CurTime() < self.Owner.lNoBurn then return end
		self.Owner:Ignite(1,100)
		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 100 )) do
			if v:IsPlayer() then
        v:Ignite(1,50)
			end
		end
    self:NextThink( CurTime() + 1)
	end
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    return false
end
