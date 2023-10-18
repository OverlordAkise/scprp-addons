--Luctus SCP "Ditto" SWEP
--Made by OverlordAkise

AddCSLuaFile()

--This SWEP lets you transform into props

--The maximum size that a prop shall have to be copyable
local MAXSIZE = 100

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "SCP-DITTO Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Left click to transform, right click to copy a prop"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "Transform"

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.AnimPrefix = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "SCP"

SWEP.IsTransformed = false
SWEP.TransformModel = ""
--currently random metal stress
SWEP.CopySound = "physics/wood/wood_box_impact_hard3.wav" 

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:Transform(model)
    if model == "" then return end
    local owner = self:GetOwner()
    if not owner or not IsValid(owner) then return end
    local pent = ents.Create("prop_physics")
    if not pent then return end
    pent:SetModel(model)
    pent:SetPos(owner:GetPos()+owner:OBBCenter())
    pent:Spawn()
    local phys = pent:GetPhysicsObject()
    if phys then
        phys:Wake()
        phys:SetVelocity(owner:GetVelocity())
    end
    owner:Spectate(OBS_MODE_CHASE)
    owner:SpectateEntity(pent)
    pent:CallOnRemove("SavePlayerFromVanish", function(ent)
        if not IsValid(self) or not IsValid(pent) or not IsValid(self:GetOwner()) then return end
        if not self.IsTransformed then return end
        self:Revert()
    end)
    self.IsTransformed = true
    self.TEnt = pent
end

function SWEP:Revert()
    self.IsTransformed = false
    local owner = self:GetOwner()
    if not owner or not IsValid(owner) then return end
    local spawnpos = owner:GetPos()
    local eyeang = owner:EyeAngles()
    if IsValid(self.TEnt) then
        spawnpos = self.TEnt:GetPos()
    end
    owner:UnSpectate()
    owner:Spawn()
    owner:SetPos(spawnpos)
    owner:SetEyeAngles(eyeang)
    owner:SelectWeapon("scp_310_de")
    if IsValid(self.TEnt) then
        self.TEnt:Remove()
    end
end

function SWEP:Holster()
    if self.IsTransformed then
        self:Revert()
    end
    return true
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextSecondaryFire(CurTime() + 0.2)
    if CLIENT then return end
    if self.IsTransformed then return end
    local trace = self.Owner:GetEyeTrace()
    local ent = trace.Entity
    if IsValid(ent) then
        if ent:GetClass() == "prop_ragdoll" or ent:IsNPC() or ent:IsPlayer() then return end
        local model = ent:GetModel()
        if not model or model == "" or ent:BoundingRadius() > MAXSIZE then return end
        self.TransformModel = model
        DarkRP.notify(self:GetOwner(),0,3,"Model Updated")
        self:GetOwner():EmitSound(self.CopySound)
    end
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextPrimaryFire(CurTime()+0.2)
    if CLIENT then return end
    if self.IsTransformed then
        self:Revert()
    else
        self:Transform(self.TransformModel)
    end
end
