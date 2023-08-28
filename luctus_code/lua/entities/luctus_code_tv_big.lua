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
ENT.Model = "models/props_phx/construct/metal_plate1.mdl"

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
    font = "Arial",
    size = 250,
    weight = 900,
})

surface.CreateFont( "luctus_code_tv_big_desc", {
    font = "Arial",
    size = 80,
    weight = 100,
})

function ENT:Draw()
    --self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 1024) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*-30) + (self:GetAngles():Up() * 4) + (self:GetAngles():Right() *45)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    cam.Start3D2D(pos, ang, 0.1)
    draw.RoundedBox(0,0,0,900,580,LUCTUS_CODE_CURRENT_COLOR)
    --fancy boxes on the bottom
    for i=1,8 do
        draw.RoundedBox(0,880-i*40,500,20,70,color_black)
    end
    draw.SimpleText(LUCTUS_CODE_CURRENT, "luctus_code_tv_big", 20, 0,color_black,TEXT_ALIGN_LEFT)
    draw.DrawText(LUCTUS_CODE_CURRENT_TV, "luctus_code_tv_big_desc", 30, 280,color_black,TEXT_ALIGN_LEFT)
    cam.End3D2D()
end
