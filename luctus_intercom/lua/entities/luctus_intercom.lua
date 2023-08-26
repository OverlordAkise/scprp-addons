--Luctus Intercom
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Intercom"
ENT.Category = "Intercom"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Speakers = {}

function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/props_combine/combine_interface001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    if not ply:IsPlayer() then return end
    LuctusIntercomAdd(ply,self)
end

if SERVER then
    function ENT:Think()
        for ply,v in pairs(self.Speakers) do
            LuctusIntercomRemoveCheck(ply,self)
        end
        self:NextThink(CurTime() + 0.3)
    end
    function ENT:OnRemove()
        for ply,v in pairs(self.Speakers) do
            LuctusIntercomRemoveCheck(ply,self,true)
        end
    end
end

if SERVER then return end

local color_white = Color(255,255,255,255)
local color_live = Color(0,255,0,255)
function ENT:Draw()
    self:DrawModel()
    if self:GetPos():Distance(LocalPlayer():GetPos()) > 500 then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()) + (self:GetAngles():Up() * 50) + (self:GetAngles():Right() *15)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),40)
    cam.Start3D2D(pos, ang, 0.4)
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( -20, -13, 115, 70 )
        draw.DrawText("INTERCOM", "TargetID", 37, 0, color_white,TEXT_ALIGN_CENTER)
        if INTERCOM_IS_TALKING then
            draw.DrawText("LIVE", "TargetID", 37, 30, color_live,TEXT_ALIGN_CENTER)
        else
            draw.DrawText("PRESS E", "TargetID", 37, 30, color_live,TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()
end
