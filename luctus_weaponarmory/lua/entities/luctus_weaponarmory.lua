--Luctus Weaponarmory
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Weapon Armory"
ENT.Author = "OverlordAkise"
ENT.Contact = "OverlordAkise@Steam"
ENT.Purpose = "Retrieve weapons!"
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Weaponarmory"


function ENT:Initialize()
    if CLIENT then return end

    self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)     
    self:SetMoveType(MOVETYPE_VPHYSICS)  
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    local comp = util.Compress(activator.LuctusWArmoryJ)
    net.Start("luctus_weaponarmory")
        net.WriteEntity(self)
        net.WriteUInt(#comp,17)
        net.WriteData(comp,#comp)
    net.Send(activator)
end

if SERVER then return end

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)
surface.CreateFont("luctusweaponarmoryentity", {
    font = "Arial",
    size = 96,
    weight = 5000,
})

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 512) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*15) + (self:GetAngles():Up() * 30) + (self:GetAngles():Right()*5)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos, ang, 0.1)
        draw.SimpleTextOutlined("Weapons", "luctusweaponarmoryentity", 37, 0, color_white,TEXT_ALIGN_CENTER,2,3,color_black)
    cam.End3D2D()
end
