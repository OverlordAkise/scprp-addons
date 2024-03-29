AddCSLuaFile()

SWEP.PrintName = "SCP096"
SWEP.Author = "OverlordAkise, Kilburn, robotboy655, MaxOfS2D & Tenrys"
SWEP.Purpose = "Weapon for SCP 096"
SWEP.Category = "SCP"

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
    self.isGDeathSystem = MedConfig and true or false
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

function SWEP:PrimaryAttack(right)
    --Door Logic
    local tr = self:GetOwner():GetEyeTrace()
    if IsValid(tr.Entity) and tr.Entity:isDoor() then
        if SERVER then
            self:OpenDoor()
        end
        self:SetNextPrimaryFire(CurTime()+2)
        return
    end
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
        self.Owner:StopSound("096/scream.wav")
        self.Owner:StopSound("096/crying1.wav")
        if scp096_hunting then
            self.Owner:EmitSound("096/scream.wav")
        else
            self.Owner:EmitSound("096/crying1.wav")
        end
    end
    self:SetNextSecondaryFire( CurTime() + 2)
end

function SWEP:Reload()
    if SERVER then
        self.Owner:StopSound("096/scream.wav")
        self.Owner:StopSound("096/crying1.wav")
    end
end

function SWEP:OpenDoor(ply,tr,ent)
    local ply = self:GetOwner()
    if not IsValid(ply) then return end
    local trace = ply:GetEyeTrace()
    local ent = trace.Entity
    if not IsValid(ent) then return end
    if not ent:isDoor() then return end
    if ply:EyePos():Distance(trace.HitPos) > 128 then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if LUCTUS_SCP096_UNBREACHABLE[trace.Entity:GetName()] or LUCTUS_SCP096_UNBREACHABLE[trace.Entity:MapCreationID()] then
        DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
        return false
    end
    
    --SCP doors:
    if ent:GetClass() == "prop_dynamic" and ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
        ent = ent:GetParent()
    end
    ent:keysUnLock()
    ent:Fire("open", "", .6)
    ent:Fire("setanimation", "open", .6)
    
    hook.Run("onDoorRamUsed", true, ply, trace)
    --ply:EmitSound(self.Sound)
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav")
end


local phys_pushscale = GetConVar( "phys_pushscale" )
function SWEP:DealDamage()

    local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

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
end

function SWEP:OnDrop()
    self:Remove()
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
    local ply = self:GetOwner()
    if ply:GetNW2Bool("scp096_bag",false) then return end
    if self.next_think > CurTime() then return end
    self.next_think = CurTime() + 0.3
    
    --StartPos, Direction, Size(Range), Degrees(Angle)
    local plyAimVec = ply:GetAimVector()
    plyAimVec.z = 0
    local eyePos = ply:EyePos()
    local entities_in_view = ents.FindInCone(eyePos-plyAimVec*50, ply:GetAimVector(), 512, math.cos(math.rad(15)))
    
    for k,v in ipairs(entities_in_view) do
        if not v:IsPlayer() then continue end
        if v == ply then continue end
        local alive = v:Alive()
        if MedConfig then
            alive = not v._IsDead
        end
        if not alive then continue end
        if LUCTUS_SCP096_IMMUNE_JOBS[team.GetName(v:Team())] then continue end
        local a1 = ply:GetAimVector()
        local a2 = v:GetAimVector():GetNegated()
        if a1:Distance(a2) < 0.8 then
            if ply:IsLineOfSightClear(v) then 
                Luctus096UpdateHunted(v,true)
            end
        end
    end
end
