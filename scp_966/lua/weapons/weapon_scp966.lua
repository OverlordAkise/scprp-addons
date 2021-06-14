AddCSLuaFile()

SWEP.PrintName = "SCP 966"
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "Slowly kill people"
SWEP.Category = "SCP"
SWEP.Instructions = "LMB to eat sleeping people, Stare at people to make them sleep"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""

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
SWEP.DrawCrosshair = true
SWEP.UseHands = false

SWEP.HoldType = "normal"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.AdminSpawnable = false


function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
  return true
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

	if trace.Hit then
		if trace.Entity and trace.Entity:GetClass() == "prop_ragdoll" and trace.Entity:CPPIGetOwner() then
			local ply,pid = trace.Entity:CPPIGetOwner()
			if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
			if CLIENT then return end
      trace.Entity:Remove() --remove ragdoll
      ply:Spawn() --respawn player
      owner:EmitSound("vo/sandwicheat09.mp3", 100, 100)
      owner:SetHealth(owner:Health()+100)
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
	end
end

function SWEP:Think()
  if CLIENT then return end
  local owner = self.Owner
  if not IsValid(owner) then return end
  local tr = owner:GetEyeTrace()
  if tr.Hit and tr.Entity and tr.Entity:IsPlayer() and tr.Entity:Alive() then
    local ply = tr.Entity
    if not ply.loldWalkSpeed then ply.loldWalkSpeed = ply:GetWalkSpeed() end
    if not ply.loldRunSpeed then ply.loldRunSpeed = ply:GetRunSpeed() end
    ply:SetWalkSpeed(ply:GetWalkSpeed() - ply.loldWalkSpeed/1000)
    ply:SetRunSpeed(ply:GetRunSpeed() - ply.loldRunSpeed/1000)
    if ply:GetWalkSpeed() < 1 then
      DarkRP.toggleSleep(ply, "force")
    end
  end
  self:NextThink(CurTime() + 0.2)
end

function SWEP:SecondaryAttack()
end
