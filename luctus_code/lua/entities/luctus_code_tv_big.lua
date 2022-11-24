--Luctus SCP Codes
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Code TV (big)"
ENT.Author = "OverlordAkise"
ENT.Contact = "OverlordAkise"
ENT.Purpose = "Display the current SCP code"
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Luctus Code"
ENT.Model = "models/u4lab/tv_monitor_plasma.mdl"

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

surface.CreateFont( "luctus_code_tv_big", {
    font = "Roboto Lt",
    size = 70,
    weight = 900,
})

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 1024) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*5) + (self:GetAngles():Up() * 62) + (self:GetAngles():Right() *45)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos, ang, 0.4)
    draw.RoundedBox(0,0,0,225,145,LUCTUS_CODE_CURRENT_COLOR)
    --fancy boxes on the bottom
    draw.RoundedBox(0,30,115,10,30,color_black)
    draw.RoundedBox(0,50,115,10,30,color_black)
    draw.RoundedBox(0,70,115,10,30,color_black)
    draw.RoundedBox(0,90,115,10,30,color_black)
    draw.RoundedBox(0,110,115,10,30,color_black)
    draw.RoundedBox(0,130,115,10,30,color_black)
    draw.RoundedBox(0,150,115,10,30,color_black)
    draw.SimpleText(LUCTUS_CODE_CURRENT, "luctus_code_tv_big", 5, 0,color_black,TEXT_ALIGN_LEFT,2,3)
    cam.End3D2D()
end
