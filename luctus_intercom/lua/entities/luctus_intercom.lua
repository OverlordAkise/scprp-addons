--Luctus Intercom
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Intercom"
ENT.Category = "Intercom"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/props_combine/combine_interface001.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(3)
    end
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 500*500) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()) + (self:GetAngles():Up() * 50) + (self:GetAngles():Right() *15)
    local ang = self:GetAngles()
    local back = Color( 0, 0, 0, 200 )
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),40)
    cam.Start3D2D(pos, ang, 0.4)
        local text = "INTERCOM"
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( -20, -13, 115, 70 )
        draw.DrawText(text, "TargetID", 37, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
        if INTERCOM_IS_TALKING then
            draw.DrawText("LIVE", "TargetID", 37, 30, Color( 0, 255, 0, 255 ),TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()
end
