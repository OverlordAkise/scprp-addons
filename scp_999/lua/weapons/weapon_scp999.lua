--THIS FILE IS MADE BY BananowyTasiemiec
--THIS FILE IS MADE BY BananowyTasiemiec

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
SWEP.Author = "BananowyTasiemiec"
SWEP.Purpose = "Heal people"
SWEP.Category = "SCP"
SWEP.Instructions = "LMB to Heal | RMB to make a sound"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.PrintName = "SCP 999"
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
	local owner = self.Owner

	tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = owner:GetShootPos() + ( owner:GetAimVector() * 95 )
	tr.filter = owner
	tr.mask = MASK_SHOT
	trace = util.TraceLine( tr )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() then
			local ply = trace.Entity
			if ply:Health() <= ply:GetMaxHealth() - 50 then
				ply:SetHealth(ply:Health() + 50)
			else
				ply:SetHealth(ply:GetMaxHealth())
			end
			if ( CLIENT ) then return end
			self.Owner:EmitSound("scp999/scp999_"..math.random(1,6)..".mp3", 75)
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
	end
end

function SWEP:SecondaryAttack()
	if ( CLIENT ) then return end
	self.Owner:EmitSound("scp999/scp999_"..math.random(1,6)..".mp3", 75)
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

local damagesoundcooldown = SWEP.DamageSoundCoolDown

hook.Add( "EntityTakeDamage", "EntityDamageExample", function( target, dmginfo )
	if target:IsPlayer() and target:HasWeapon("bt_scp999") then
		if target:GetActiveWeapon():GetClass() == "bt_scp999" then
			if damagesoundcooldown <= CurTime() then
				damagesoundcooldown = CurTime() + 5
				target:EmitSound("scp999/scp999_damage.mp3", 75)
			end
		end
	end
end )