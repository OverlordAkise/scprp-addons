--Luctus Washsaloon
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Clothes"
ENT.Author = "OverlordAkise"
ENT.Purpose = ""
ENT.Instructions = "N/A"
ENT.Category = "Washsaloon"
ENT.Model = "models/props/de_tides/vending_tshirt.mdl"

ENT.Freeze = true

ENT.Spawnable = true
ENT.AdminSpawnable = true

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetColor(Color(85,37,37,255))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Use(ply, caller, useType, value)
        if not IsValid(ply) or not ply:IsPlayer() then return end
        if self:IsPlayerHolding() then return end
        ply:PickupObject(self)
    end
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel() 
end

function ENT:OnRemove()
    self:EmitSound("player/footsteps/chainlink2.wav", 100, 100)
end
