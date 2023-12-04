--Luctus Buildtablet
--Made by OverlordAkise

AddCSLuaFile()

SWEP.PrintName = "Buildtablet"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Build props"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.UseHands = true
SWEP.Category = "Luctus Buildtablet"

SWEP.ViewModel  = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/props/cs_office/computer_monitor_p2a.mdl"

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip  = -1
SWEP.Primary.Automatic    = false
SWEP.Primary.Ammo      = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic  = false
SWEP.Secondary.Ammo      = "none"

SWEP.AutoSwitchTo      = false
SWEP.AutoSwitchFrom      = false

SWEP.useCD = 0
SWEP.csmodel = nil
SWEP.PropModel = nil
SWEP.PropAngOffset = nil
SWEP.PropSpawnTime = 3
SWEP.PropHeightOffset = 0
SWEP.PropHealth = 100

function SWEP:Initialize()
    self:SetHoldType("slam")
    local k,v = next(LUCTUS_BUILDTABLET_PROPS)
    self.PropModel = v[1]
    self.PropHealth = v[2]
    self.PropSpawnTime = v[3]
    self.PropAngOffset = v[4]
    self.PropHeightOffset = v[5]
    if SERVER then return end
    timer.Simple(0.1,function()
        if not IsValid(self) then return end
        if not IsValid(self:GetOwner()) then return end
        if self:GetOwner() ~= LocalPlayer() then return end
        if self.csmodel then return end
        self:Deploy()
    end)
end

function SWEP:UpdateCSModel()
    if SERVER then return end
    self.csmodel:SetModel(self.PropModel)
end

function SWEP:Deploy()
    if SERVER then return true end
    if not self.csmodel then
        local k,v = next(LUCTUS_BUILDTABLET_PROPS)
        self.csmodel = ClientsideModel(v[1])
        self.csmodel:SetMaterial("models/wireframe")
        self.csmodel:SetNoDraw(true)
    end
    hook.Add("PostDrawOpaqueRenderables","luctus_buildtablet_preview",function()
        if not IsValid(self.csmodel) then return end
        local ply = self:GetOwner()
        local pos = ply:GetEyeTrace().HitPos
        if ply:GetPos():Distance(pos) > 256 then return end
        if self.PropHeightOffset then
            pos:Add(Vector(0,0,self.PropHeightOffset))
        end
        self.csmodel:SetPos(pos)
        local ang = ply:GetAimVector():Angle()
        ang[1] = 0
        if self.PropAngOffset then
            ang = ang + self.PropAngOffset
        end
        self.csmodel:SetAngles(ang)
        self.csmodel:DrawModel()
    end)
    return true
end

function SWEP:Holster()
    if SERVER then return true end
    if self:GetOwner() ~= LocalPlayer() then return true end
    hook.Remove("PostDrawOpaqueRenderables","luctus_buildtablet_preview")
    return true
end

function SWEP:OnRemove() return true end
function SWEP:Think() end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    local ply = self:GetOwner()
    if self.useCD > CurTime() then
        return
    end
    self.useCD = CurTime()+LUCTUS_BUILDTABLET_COOLDOWN
    if not LuctusBuildtabletCanSpawn(ply) then
        if SERVER then DarkRP.notify(ply,1,5,"You reached the prop limit!") end
        return
    end
    local pos = ply:GetEyeTrace().HitPos
    if ply:GetPos():Distance(pos) > 256 then return end
    
    local cent = ents.Create("luctus_bprop")
    cent.Model = self.PropModel
    cent:SetModel(self.PropModel)
    if self.PropHeightOffset then
        pos = pos + Vector(0,0,self.PropHeightOffset)
    end
    cent:SetPos(pos)
    local ang = ply:GetAimVector():Angle()
    ang[1] = 0
    if self.PropAngOffset then
        ang = ang + self.PropAngOffset
    end
    cent:SetAngles(ang)
    cent:Spawn()
    cent.Health = self.PropHealth
    cent.FromBuildtablet = true
    cent.creator = ply
    local oldCol = cent:GetCollisionGroup()
    cent:SetCollisionGroup(COLLISION_GROUP_WEAPON) --dont collide with players
    timer.Simple(self.PropSpawnTime,function()
        if not IsValid(cent) then return end
        cent:SetCollisionGroup(oldCol)
        cent:EmitSound("physics/cardboard/cardboard_box_impact_hard7.wav")
        local ef = EffectData()
        ef:SetOrigin(cent:GetPos())
        util.Effect("ManhackSparks",ef)
    end)
    LuctusBuildtabletPropcountSubtract(ply)
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    local ply = self:GetOwner()
    if self.useCD > CurTime() then
        return
    end
    self.useCD = CurTime()+LUCTUS_BUILDTABLET_COOLDOWN
    local ent = ply:GetEyeTrace().Entity
    if IsValid(ent) and ent:GetClass() == "luctus_bprop" and ent.FromBuildtablet then
        if ent.creator ~= ply then
            DarkRP.notify(ply,1,5,"You can not remove other's buildings!")
            return
        end
        ent:EmitSound("physics/concrete/concrete_break3.wav")
        ent:Remove()
        LuctusBuildtabletPropcountRecover(ply)
    end
end

function SWEP:FireAnimationEvent() return true end
function SWEP:ShouldDrawViewModel() return false end


SWEP.cur = 1
local last = 0
function SWEP:Reload()
    if last > CurTime() then return end
    last = CurTime()+0.2
    self.cur = (self.cur)%#LUCTUS_BUILDTABLET_PROPS+1
    if not LUCTUS_BUILDTABLET_PROPS[self.cur] then return end
    --TODO: Make menu here
    self.PropModel = LUCTUS_BUILDTABLET_PROPS[self.cur][1]
    self.PropHealth = LUCTUS_BUILDTABLET_PROPS[self.cur][2]
    self.PropSpawnTime = LUCTUS_BUILDTABLET_PROPS[self.cur][3]
    self.PropAngOffset = LUCTUS_BUILDTABLET_PROPS[self.cur][4]
    self.PropHeightOffset = LUCTUS_BUILDTABLET_PROPS[self.cur][5]
    self:UpdateCSModel()
end

if SERVER then return end



function SWEP:Think() end

function SWEP:DrawHUD()
    draw.SimpleTextOutlined("Leftclick = place prop", "DermaLarge", 10, ScrH()/2.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
    draw.SimpleTextOutlined("Rightclick = remove prop", "DermaLarge", 10, ScrH()/2.5+40, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
    draw.SimpleTextOutlined("Reload = select prop", "DermaLarge", 10, ScrH()/2.5+80, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
end

function SWEP:ShouldDrawViewModel() return false end

function SWEP:DrawWorldModel(flags)
    local owner = self:GetOwner()
    if not IsValid(owner) then
        self:DrawModel(flags)
        return
    end
    local bi = self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand")
    if not bi then return end
    local bpos,bang = self:GetOwner():GetBonePosition(bi)
    bang:RotateAroundAxis(bang:Right(),-120)
    bpos = bpos + bang:Forward()*-2 + bang:Right()*7 + bang:Up()*-2
    self:SetRenderOrigin(bpos)
    self:SetRenderAngles(bang)
    self:SetModelScale(0.7,0)
    self:DrawModel()
end
