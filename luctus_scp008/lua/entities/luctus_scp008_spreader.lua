--Luctus SCP 008 System
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Name = "SCP 008 Spreader"
ENT.PrintName = "SCP 008 Spreader"
ENT.Author = "OverlordAkise"
ENT.Category = "SCP"
ENT.Purpose = "SCP"
ENT.Instructions = "N/A"
ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"

ENT.Freeze = true

ENT.Spawnable = true
ENT.AdminSpawnable = true

if CLIENT then
    function ENT:Initialize()
        self:SetNoDraw(not LUCTUS_SCP008_DEBUG)
    end
end

if CLIENT then return end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
    self:SetTrigger(true)
    self:DrawShadow(false)
    self:SetNoDraw(not LUCTUS_SCP008_DEBUG)
end

function ENT:Use() return end
function ENT:Think() end
