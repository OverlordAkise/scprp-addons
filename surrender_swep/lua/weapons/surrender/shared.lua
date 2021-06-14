if CLIENT then
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
end
SWEP.Base = "leafy_base"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 4
SWEP.PrintName = "Surrender"
SWEP.Author = "Leafdroid"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 1
SWEP.DrawCrosshair = false
SWEP.CustomCrosshair = false
SWEP.CrossColor = Color( 0, 255, 0, 150 )
SWEP.Category = "Handies"
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.Instructions = "Hold left click to surrender and right click to call for help"
SWEP.Contact = "Leafdroids@gmail.com"
SWEP.Purpose = "Surrender"
SWEP.HoldType = "normal"
SWEP.ViewModelFOV = 113
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.LaserSight = 0
SWEP.Dissolve = 1

SWEP.IronsightTime = 0.1
SWEP.DisableMuzzle = 1
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45.555, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 1.11, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 78.888, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 70, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 63.333, -18.889) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 114.444, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -21.112, 0) },
	["ValveBiped.base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.333, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-16.852, -2.408, -7.593), angle = Angle(21.111, -70, -16.667) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(4.258, -2.408, -2.037), angle = Angle(-94.445, 101.111, -110) },
	["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(18.888, 78.888, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.777, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 36.666, 0) },
	["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.444, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 72.222, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-50, -58.889, 74.444) },
	["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.111, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.333, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.222, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(45.555, -12.223, -87.778) },
	["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 34.444, 0) },
	["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 65.555, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.778, 47.777, 0) },
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 72.222, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.111, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 85.555, 0) },
	["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 96.666, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.777, 43.333, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 47.777, 0) },
	["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 70, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.111, 0) }
}
SWEP.IronSightsPos = Vector(-0, -7, 1.629)
SWEP.IronSightsAng = Vector(-1, 0, 0)

//SWEP.PrimaryReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.PrimarySound = Sound("weapons/ar1/ar1_dist2.wav")

SWEP.Primary.Delay       = 0.9
SWEP.Primary.Recoil      = 0
SWEP.Primary.Damage      = 0
SWEP.Primary.NumShots    = 1
SWEP.Primary.Cone        = 0
SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "none"

SWEP.Secondary.Delay        = 0.9
SWEP.Secondary.Recoil       = 0
SWEP.Secondary.Damage       = 0
SWEP.Secondary.NumShots     = 1
SWEP.Secondary.Cone         = 0
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"

SWEP.IronFOV = 70

--if CLIENT then

function SWEP:DoBones()
local FT = FrameTime()

local ply = self.Owner
local ang1 = ply:GetNWFloat("ang1")
local ang2 = ply:GetNWFloat("ang2")

	if IsValid(ply) then
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(0, -45*ang1, 2)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].pos = Vector(0 , -21 +(15*ang1), -6)
		self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].angle = Angle(-99, -63*ang1, 54)
		self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].pos = Vector(-5 , -39 +(32*ang1), 1)
	end
end

--end

function SWEP:SecondThink()

local ply = self.Owner
local FT = FrameTime()

local ang1 = ply:GetNWFloat("ang1")
local ang2 = ply:GetNWFloat("ang2")

if self.Owner:KeyDown(IN_ATTACK) then
ply:SetNWFloat("ang1", Lerp(FT*7, ang1, 1) )
ply:SetNWFloat("ang2", Lerp(FT*7, ang1, 45) )
else
ply:SetNWFloat("ang1", Lerp(FT*7, ang1, 0) )
ply:SetNWFloat("ang2", Lerp(FT*7, ang2, 0) )
end

	if IsValid(ply) and SERVER then
		
		
		local bone = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(25*ang1,-65*ang1,25*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(-25*ang1,-65*ang1,-25*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(-70*ang1,-180*ang1,70*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(70*ang1,-180*ang1,-70*ang1) )
		end
		
	end

end



function SWEP:Holster()
local ply = self.Owner
	if IsValid(ply) then
		
	if SERVER then
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(0, 0, 0)
		self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].angle = Angle(0, 0, 0)
		
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		end
	end
	end
	
	if CLIENT and IsValid(self.Owner) and self.Owner:IsPlayer() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
return true
end


function SWEP:PrimaryAttack()

end

function SWEP:Reload()

end

SWEP.NxtSec = 0

function SWEP:SecondaryAttack()
//No ironsights, mothefucker, deal with it!
if self.NxtSec < CurTime() then
self.Weapon:EmitSound("vo/npc/male01/help01.wav")
self.NxtSec = CurTime() + 2.3
end
end

function SWEP:QuadsHere()
end

SWEP.VElements = {
}
SWEP.WElements = {
}
