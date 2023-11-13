--Luctus Buildtablet
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Name = "Prop (Buildtablet)"
ENT.PrintName = "Prop"
ENT.Author = "OverlordAkise"
ENT.Category = "SCP"
ENT.Purpose = "SCP"
ENT.Instructions = "N/A"
--ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"
ENT.Freeze = true
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.FromBuildtablet = true
ENT.hp = 100 --default fallback

function ENT:Initialize()
    --self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
    self:DrawShadow(false)
end

function ENT:OnTakeDamage(dmginfo)
    self.hp = self.hp - dmginfo:GetDamage()
    if self.hp <= 0 then
        self:EmitSound("physics/concrete/concrete_break2.wav")
        if self.creator and IsValid(self.creator) and self.creator:IsPlayer() then
            LuctusBuildtabletPropcountRecover(self.creator)
        end
        self:Remove()
    end
end
