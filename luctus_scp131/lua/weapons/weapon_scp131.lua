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
SWEP.Weight = 3
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.UseHands = false
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "Empty hands"
SWEP.Category = "SCP"
SWEP.Instructions = "Empty"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.PrintName = "SCP 131"
SWEP.HoldType = "normal"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.ISSCP = true
SWEP.DamageSoundCoolDown = 0

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
end

function SWEP:Holster()
    return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end
