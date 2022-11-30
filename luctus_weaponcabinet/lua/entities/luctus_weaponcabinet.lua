--Luctus Weaponcabinet
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Weapon Cabinet"
ENT.Author = "OverlordAkise"
ENT.Contact = "OverlordAkise@Steam"
ENT.Purpose = "Retrieve weapons!"
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Weaponcabinet"


function ENT:Initialize()
    if CLIENT then return end

    self:SetModel( "models/props_wasteland/kitchen_fridge001a.mdl" )
    --self:SetModel( "models/props_wasteland/controlroom_storagecloset001a.mdl" )
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

function ENT:Use( activator, caller )
	if activator:IsPlayer() then
        net.Start("luctus_weaponcabinet")
            net.WriteEntity(self)
        net.Send(activator)
	end
end

if SERVER then return end

surface.CreateFont( "lucid_food_font", {
    font = "Roboto Lt",
    size = 65,
    weight = 500,
})

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 512) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*25) + (self:GetAngles():Up() * 90) + (self:GetAngles():Right() *15)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos, ang, 0.4)
    draw.SimpleTextOutlined("Weapons", "DermaLarge", 37, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,2,3,color_black)
    cam.End3D2D()
end
