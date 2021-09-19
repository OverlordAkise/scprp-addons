
AddCSLuaFile()

SWEP.PrintName = "SCP096"
SWEP.Author = "OverlordAkise, Kilburn, robotboy655, MaxOfS2D & Tenrys"
SWEP.Purpose = "Weapon for SCP 096"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

--SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.ViewModel = "models/weapons/v_arms_scp096.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

SWEP.next_think = 0

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

function SWEP:PrimaryAttack( right )
  if #scp096_hunted_players == 0 then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
  local right = true
	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:DealDamage()
  self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryFire( CurTime() + 0.2 ) --0.9
	self:SetNextSecondaryFire( CurTime() + 0.2 ) --0.9
end

function SWEP:SecondaryAttack()
  if SERVER then
    self.Owner:StopSound( "096/scream.wav" )
    self.Owner:StopSound( "096/crying1.wav" )
    if scp096_hunting then
      self.Owner:EmitSound( "096/scream.wav" )
    else
      self.Owner:EmitSound( "096/crying1.wav" )
    end
  end
  self:SetNextSecondaryFire( CurTime() + 2)
end

function SWEP:Reload()
  if SERVER then
    self.Owner:StopSound( "096/scream.wav" )
    self.Owner:StopSound( "096/crying1.wav" )
  end
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage(9999)

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 * scale + self.Owner:GetForward() * 9989 * scale )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 * scale + self.Owner:GetForward() * 10012 * scale )
			dmginfo:SetDamage( math.random( 12, 24 ) )
		end

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( self.Owner )

		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function SWEP:Deploy()

	local speed = GetConVarNumber( "sv_defaultdeployspeed" )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	return true

end

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )

	return true

end

function SWEP:Think()
  if CLIENT then return end
  if self.next_think > CurTime() then return end
  self.next_think = CurTime() + 0.3
  
  --StartPos, Direction, Size(Range), Degrees(Angle)
	local entities_in_view = ents.FindInCone( self.Owner:EyePos(), self.Owner:GetAimVector(), 200, math.cos( math.rad( 15 ) ) )

  local players = {}
  for k,v in pairs(entities_in_view) do
    if v:IsPlayer() then
      --print(self.Owner:GetAngles())
      --print(v:GetAngles())
      local phi = math.abs(self.Owner:GetAngles()[2] - v:GetAngles()[2]) % 360;
      local distance = phi > 180 and 360 - phi or phi;
      --PrintMessage(3,distance)
      --From side to side: 90 <-> 90 degrees, middle: 180degrees
      if distance > 135 then
        luctus_update_hunted(v,true)
      end
    end
  end
  
end
