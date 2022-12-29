--Luctus SCP 008 System
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Name = "SCP 008 DoorChecker"
ENT.PrintName = "SCP 008 DoorChecker"
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
        if not LUCTUS_SCP008_DEBUG then
            self:SetNoDraw(true)
        end
    end
end

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
        self:SetTrigger(true)
        self:DrawShadow(false)
        if not LUCTUS_SCP008_DEBUG then
            self:SetNoDraw(true)
        end
    end
    
    function ENT:StartTouch(ent)
        if ent:IsPlayer() then return end
        if LUCTUS_SCP008_DEBUG then
            PrintMessage(HUD_PRINTTALK, "Hatch closed (StartTouch)")
        end
        LuctusSCP008StopContainment()
    end
    function ENT:EndTouch(ent)
        if ent:IsPlayer() then return end
        if LUCTUS_SCP008_DEBUG then
            PrintMessage(HUD_PRINTTALK, "Hatch opened (EndTouch)")
        end
        LuctusSCP008StartContainment()
    end
    
    function ENT:Use(activator,caller) return end
    function ENT:Think() end
end
