--Luctus SCP173 System
--Made by OverlordAkise

AddCSLuaFile()

SWEP.Base = "weapon_cuff_base"

SWEP.Category = "SCP"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Recontain SCP173"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.PrintName = "Cell (SCP173 ReC)"

SWEP.CuffTime = 5.0 --Seconds to handcuff
SWEP.CuffSound = Sound("buttons/lever7.wav")
--New:
SWEP.CuffMaterial = "models/scp173box/scp173containmentbox.mdl"

SWEP.CuffRope = "cable/blue"
SWEP.CuffStrength = 1.0
SWEP.CuffRegen = 0.4
SWEP.RopeLength = 100
SWEP.CuffReusable = false
SWEP.CuffBlindfold = false
SWEP.CuffGag = false
SWEP.CuffStrengthVariance = 0.1
SWEP.CuffRegenVariance = 0.1

function SWEP:PrimaryAttack()
    local tr = self:GetOwner():GetEyeTrace()
    if not IsValid(tr.Entity) or not tr.Entity:IsPlayer() or tr.Entity:Team() != TEAM_SCP173 then return end
    --To not copy everything of the base over:
    weapons.Get("weapon_cuff_base")["PrimaryAttack"](self)
end

--Change the holdtype dynamically:
function SWEP:Think()
	if SERVER then
		if self:GetIsCuffing() then
			local tr = self:TargetTrace()
			if (not tr) or tr.Entity~=self:GetCuffing() then
				self:SetIsCuffing(false)
				self:SetCuffTime( 0 )
				return
			end
			
			if CurTime()>self:GetCuffTime() then
				self:SetIsCuffing( false )
				self:SetCuffTime( CurTime() + self.CuffRecharge )
				self:DoHandcuff( self:GetCuffing() )
			end
		end
	end
    --New:
	if self:GetIsCuffing() then
		self:SetHoldType("pistol")
	else
		self:SetHoldType("slam")
	end
end

--This model is local, which means we have to copy everything:
local renderpos = {
	left = {pos=Vector(0,0,0), vel=Vector(0,0,0), gravity=1, ang=Angle(0,30,90)},
	right = {bone = "ValveBiped.Bip01_R_Hand", pos=Vector(3.2,2.1,0.4), ang=Angle(-2,0,80), scale = Vector(0.045,0.045,0.03)},
	rope = {l = Vector(0,0,2.0), r = Vector(2.3,-1.9,2.7)},
}
local CuffMdl = "models/scp173box/scp173containmentbox.mdl"
local RopeCol = Color(255,255,255)
function SWEP:ViewModelDrawn( vm )
	if not IsValid(vm) then return end
	
	vm:SetMaterial( "engine/occlusionproxy" )
	
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_RightCuff:SetNoDraw( true )
		self.cmdl_RightCuff:SetParent( vm )
	end
	
	local rpos, rang = self:GetBonePos( renderpos.right.bone, vm )
	if not (rpos and rang) then return end
	
	// Right
	local fixed_rpos = rpos + (rang:Forward()*renderpos.right.pos.x) + (rang:Right()*renderpos.right.pos.y) + (rang:Up()*renderpos.right.pos.z)
	self.cmdl_RightCuff:SetPos( fixed_rpos )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() // Prevents moving axes
	rang:RotateAroundAxis( u, renderpos.right.ang.y )
	rang:RotateAroundAxis( r, renderpos.right.ang.p )
	rang:RotateAroundAxis( f, renderpos.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )
	
	local matrix = Matrix()
	matrix:Scale( renderpos.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_RightCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_RightCuff:DrawModel()
end

--Right Hand Vector is 0, so we have to copy everything:
SWEP.wrender = {
	left = {pos=Vector(0,0,0), vel=Vector(0,0,0), gravity=1, ang=Angle(0,30,90)},
	right = {bone = "ValveBiped.Bip01_R_Hand", pos=Vector(2.95,2.5,-0.2), ang=Angle(30,0,90), scale = Vector(0,0,0)},
	rope = {l = Vector(0,0,2), r = Vector(3,-1.65,1)},
}
function SWEP:DrawWorldModel()
	if not IsValid(self.Owner) then return end
	local wrender = self.wrender
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_LeftCuff:SetNoDraw( true )
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_RightCuff:SetNoDraw( true )
	end
	
	local rpos, rang = self:GetBonePos( wrender.right.bone, self.Owner )
	if not (rpos and rang) then return end
	
	// Right
	local fixed_rpos = rpos + (rang:Forward()*wrender.right.pos.x) + (rang:Right()*wrender.right.pos.y) + (rang:Up()*wrender.right.pos.z)
	self.cmdl_RightCuff:SetPos( fixed_rpos )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() // Prevents moving axes
	rang:RotateAroundAxis( u, wrender.right.ang.y )
	rang:RotateAroundAxis( r, wrender.right.ang.p )
	rang:RotateAroundAxis( f, wrender.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )
	
	local matrix = Matrix()
	matrix:Scale( wrender.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_RightCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_RightCuff:DrawModel()
	
	// Left
	if CurTime()>(wrender.left.NextThink or 0) then
		local dist = wrender.left.pos:Distance( fixed_rpos )
		if dist>100 then
			wrender.left.pos = fixed_rpos
			wrender.left.vel = Vector(0,0,0)
		elseif dist > 10 then
			local target = (fixed_rpos - wrender.left.pos)*0.3
			wrender.left.vel.x = math.Approach( wrender.left.vel.x, target.x, 1 )
			wrender.left.vel.y = math.Approach( wrender.left.vel.y, target.y, 1 )
			wrender.left.vel.z = math.Approach( wrender.left.vel.z, target.z, 3 )
		end
		
		wrender.left.vel.x = math.Approach( wrender.left.vel.x, 0, 0.5 )
		wrender.left.vel.y = math.Approach( wrender.left.vel.y, 0, 0.5 )
		wrender.left.vel.z = math.Approach( wrender.left.vel.z, 0, 0.5 )
		-- if wrender.left.vel:Length()>10 then wrender.left.vel:Mul(0.1) end
		
		local targetZ = ((fixed_rpos.z - 10) - wrender.left.pos.z) * wrender.left.gravity
		wrender.left.vel.z = math.Approach( wrender.left.vel.z, targetZ, 3 )
		
		wrender.left.pos:Add( wrender.left.vel )
		
		-- wrender.left.NextThink = CurTime()+0
	end
	
	self.cmdl_LeftCuff:SetPos( wrender.left.pos )
	self.cmdl_LeftCuff:SetAngles( wrender.left.ang )
	
	local matrix = Matrix()
	matrix:Scale( wrender.right.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_LeftCuff:DrawModel()
	
	// Rope
	if not self.RopeMat then self.RopeMat = Material(self.CuffRope) end
	
	render.SetMaterial( self.RopeMat )
	render.DrawBeam( wrender.left.pos + wrender.rope.l,
		rpos + (rang:Forward()*wrender.rope.r.x) + (rang:Right()*wrender.rope.r.y) + (rang:Up()*wrender.rope.r.z),
		0.7, 0, 5, RopeCol )
end

print("[SCP173] cuff Loaded!")
