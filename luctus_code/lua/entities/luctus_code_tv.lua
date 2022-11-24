--Luctus SCP Codes
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Code TV"
ENT.Author = "OverlordAkise"
ENT.Contact = "OverlordAkise"
ENT.Purpose = "Display the current SCP code"
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Luctus Code"
ENT.Model = "models/props/cs_office/tv_plasma.mdl"

function ENT:Initialize()
    if CLIENT then return end

    self:SetModel(self.Model)
    self:PhysicsInit( SOLID_VPHYSICS )     
    self:SetMoveType( MOVETYPE_VPHYSICS )  
    self:SetSolid( SOLID_VPHYSICS )

    local p = self:GetPos()
    --p.z = p.z + 55
    self:SetPos(p)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

if SERVER then return end

surface.CreateFont( "luctus_code_tv", {
    font = "Bahnschrift",
    size = 40,
    weight = 900,
})

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 1024) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*6.2) + (self:GetAngles():Up() * 34) + (self:GetAngles():Right() *40)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos, ang, 0.4)
    draw.RoundedBox(0,28,-6,142,90,LUCTUS_CODE_CURRENT_COLOR)
    --fancy boxes on the bottom
    draw.RoundedBox(0,38,50,10,30,color_black)
    draw.RoundedBox(0,58,50,10,30,color_black)
    draw.RoundedBox(0,78,50,10,30,color_black)
    draw.RoundedBox(0,98,50,10,30,color_black)
    draw.RoundedBox(0,118,50,10,30,color_black)
    draw.SimpleText(LUCTUS_CODE_CURRENT, "luctus_code_tv", 32, -5,color_black,TEXT_ALIGN_LEFT,2,3)
    cam.End3D2D()
end
