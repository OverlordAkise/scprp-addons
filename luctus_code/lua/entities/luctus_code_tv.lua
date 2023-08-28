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
    font = "Arial",
    size = 140,
    weight = 900,
})

surface.CreateFont( "luctus_code_tv_desc", {
    font = "Arial",
    size = 50,
    weight = 100,
    antialias = true,
})

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 1024) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*6.2) + (self:GetAngles():Up() * 34) + (self:GetAngles():Right() *30)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos, ang, 0.1)
    draw.RoundedBox(0,28,-6,540,310,LUCTUS_CODE_CURRENT_COLOR)
    --fancy boxes on the bottom
    for i=1,8 do
        draw.RoundedBox(0,540-i*20,260,10,40,color_black)
    end
    draw.SimpleText(LUCTUS_CODE_CURRENT, "luctus_code_tv", 50, -5,color_black,TEXT_ALIGN_LEFT)
    draw.DrawText(LUCTUS_CODE_CURRENT_TV, "luctus_code_tv_desc", 60, 140,color_black,TEXT_ALIGN_LEFT)
    cam.End3D2D()
end
