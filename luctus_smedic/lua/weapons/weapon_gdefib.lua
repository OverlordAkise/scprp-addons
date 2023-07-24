--Luctus Medic (SCP)
--Made by OverlordAkise

AddCSLuaFile()
SWEP.PrintName = "Defibrilator"
SWEP.Category = "Medic"
SWEP.Instructions = "Left click to revive/attack!"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.ViewModelFOV = 62

SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.ViewModel = "models/weapons/c_defib_gonzo.mdl"
SWEP.WorldModel = "models/weapons/c_defib_gonzo.mdl"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "Charge")
end

function SWEP:CreateEffect(pos, ent)
    local vPoint = pos
    local effectdata = EffectData()
    effectdata:SetOrigin(vPoint)
    effectdata:SetMagnitude(20)
    effectdata:SetScale(20)
    effectdata:SetEntity(ent)
    util.Effect("TeslaHitboxes", effectdata)
end

function SWEP:PrimaryAttack()
    
    if not IsFirstTimePredicted() then return end
    if self:GetCharge() <= 0 then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    local trace = util.QuickTrace(owner:GetShootPos(), owner:GetAimVector() * 96, owner)

    if IsValid(trace.Entity) and trace.Entity.isDeathRagdoll then
        if not trace.Entity.isBleedingOut or trace.Entity.isFullyDead then
            DarkRP.notify(owner,1,5,"This player is already dead!")
            return
        end
        if LUCTUS_MEDIC_IMMUNE_TEAMS[team.GetName(trace.Entity.deathOwner:Team())] and not LUCTUS_MEDIC_IMMUNE_BUT_REVIVEABLE[team.GetName(trace.Entity.deathOwner:Team())] then return end
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        timer.Simple(0.3, function()
            self:SetCharge(0)
            self:EmitSound("ambient/energy/spark"..math.random(1,5)..".wav")
            self:CreateEffect(owner:GetShootPos(), trace.Entity)
            if SERVER then
                trace.Entity:GetPhysicsObject():ApplyForceCenter(Vector(0,0,math.random(300,5000)*10))
                local ply = trace.Entity.deathOwner
                if not IsValid(ply) or not ply:IsPlayer() then return end
                if LUCTUS_MEDIC_REVIVE_COST > 0 then
                    owner:addMoney(LUCTUS_MEDIC_REVIVE_COST)
                    DarkRP.notify(owner, 3, 5, "You've revived a player, take $"..LUCTUS_MEDIC_REVIVE_COST)
                    if ply:canAfford(LUCTUS_MEDIC_REVIVE_COST) then
                        ply:addMoney(-LUCTUS_MEDIC_REVIVE_COST)
                        DarkRP.notify(ply, 3, 6, "You've paid $"..LUCTUS_MEDIC_REVIVE_COST.." for medical fees")
                    end
                end
                
                local plyPos = trace.Entity:GetPos()+Vector(0,0,15)
                ply:Spawn()
                ply:SetPos(plyPos)
                ply:SetHealth(math.random(1,25))
                timer.Simple(0.2, function()
                    LuctusMedicReturnWeapons(ply)
                end)
            end
        end)
    elseif trace.Entity:IsPlayer() then
        self:SetCharge(0)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        timer.Simple(0.3, function()
            trace.Entity:SetLocalVelocity(owner:GetAimVector() * 500)
            if SERVER then
                local dmg = DamageInfo()
                dmg:SetDamage(500)
                dmg:SetDamageType(DMG_SHOCK)
                dmg:SetAttacker(owner)
                trace.Entity:TakeDamageInfo(dmg)
            end
            self:CreateEffect(owner:GetShootPos(), trace.Entity)
            self:EmitSound("ambient/energy/spark"..math.random(1,5)..".wav")
        end)
        
    end
    self:SetNextSecondaryFire(CurTime()+1)
end

function SWEP:Reload()
    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
end

function SWEP:SecondaryAttack()
    if  self:GetCharge() > 0 then return end
    self:SetNextSecondaryFire(CurTime() + 5 + 2)
    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    if SERVER or not IsFirstTimePredicted() then
        self:GetOwner():EmitSound("buttons/button1.wav")
        timer.Simple(1.3, function()
            if (IsValid(self) and self:GetOwner():GetActiveWeapon() == self) then
                self:SetCharge(100)
            end
        end)
    end
end

function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
    local bone, pos, ang
    if tab.rel and tab.rel != "" then
        local v = basetab[tab.rel]
        if not v then return end

        pos, ang = self:GetBoneOrientation( basetab, v, ent )

        if not pos then return end

        pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)
    else
        bone = ent:LookupBone(bone_override or tab.bone)
        if not bone then return end
        
        pos, ang = Vector(0,0,0), Angle(0,0,0)
        local m = ent:GetBoneMatrix(bone)
        if m then
            pos, ang = m:GetTranslation(), m:GetAngles()
        end

        if (IsValid(self.Owner) and self.Owner:IsPlayer() and
            ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
            ang.r = -ang.r
        end

    end

    return pos, ang
end

function SWEP:Think()
    if self:GetCharge() > 0 then
        self:SetCharge(self:GetCharge() - 1)
    end
end

function SWEP:ViewModelDrawn(vm)
    
    local pos,ang = self:GetBoneOrientation( {}, {}, vm, "screen_l" )
    pos = pos + ang:Up() * 0.1
    ang:RotateAroundAxis(ang:Forward(),60)

    cam.Start3D2D(pos, ang, 0.02)
        surface.SetDrawColor(Color(200,0,0,255))
        surface.DrawRect(0, 72 * (1 - self:GetCharge() / 100), 68, 72 * (self:GetCharge() / 100))
    cam.End3D2D()

    local pos,ang = self:GetBoneOrientation( {}, {}, vm, "screen_r" )
    pos = pos + ang:Up() * 0.1
    ang:RotateAroundAxis(ang:Forward(),60)

    cam.Start3D2D(pos, ang, 0.02)
        surface.SetDrawColor(Color(200,0,0,255))
        surface.DrawRect(0, 72 * (1 - self:GetCharge() / 100), 68, 72 * (self:GetCharge() / 100))
    cam.End3D2D()

    vm:SetBodygroup(0, 1)
end

function SWEP:DrawWorldModel()
    self:DrawModel()
    self:SetModelScale(0.8, 0)
end

function SWEP:Initialize()
    self:SetHoldType("knife")
end

function SWEP:Deploy()
    self:SetCharge(0)
    self.Owner.Discharge = false
    return true
end

function SWEP:Holster()
    return true
end
