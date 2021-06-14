AddCSLuaFile( "shared.lua" )

include('shared.lua')

function SWEP:Initialize()
self:SetWeaponHoldType("ar2")
if self.Owner:IsNPC() then
		
	if self.Owner:GetClass() == "npc_combine_s" then
		if self.Weapon.Owner:LookupSequence("cover_crouch_low") == nil then return end
		local crouchseq = self.Weapon.Owner:LookupSequence("cover_crouch_low") 
				if self.Weapon.Owner:GetSequenceName(crouchseq) == "cover_crouch_low" then	
					self:SetWeaponHoldType("ar2")
					else
					self:SetWeaponHoldType("pistol")
				end
	end
	
	if self.Owner:GetClass() == "npc_combine_s" then
	hook.Add( "Think", self, self.TheThink )
	end
	
	if self.Owner:GetClass() == "npc_metropolice" then
	self:SetWeaponHoldType("smg")	
    end
	
	self.Weapon.Owner:SetKeyValue( "spawnflags", "256" )
	
	if self.Owner:GetClass() == "npc_citizen" then
	self.Weapon.Owner:Fire( "DisableWeaponPickup" )
	end
	end
end

function SWEP:TheThink()
if self.Owner:IsNPC() then
self:NextFire()
end
end

function SWEP:NextFire()
	if !self:IsValid() or !self.Owner:IsValid() then return; end
	if self.Owner:IsNPC() then
	if self:GetOwner():GetActivity() == 16 then
		self:NPCShoot_Primary( ShootPos, ShootDir )
			hook.Remove("Think", self)
			
	timer.Simple(0.3, function()
		hook.Add("Think", self, self.NextFire)
		end)
	end
		end
end	

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
//if self.Owner:IsNPC() then
	if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end 
	self:PrimaryAttack()
	
		timer.Simple(0.15, function()
			if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end
				if (!self.Owner:GetEnemy()) then return; end 
					self:PrimaryAttack()
					end)
							timer.Simple(0.3, function()
			if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end
				if (!self.Owner:GetEnemy()) then return; end 
					self:PrimaryAttack()
					end)
//end
end