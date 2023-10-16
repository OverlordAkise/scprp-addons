--Luctus Disguise
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Disguise Cabinet"
ENT.Author = "OverlordAkise"
ENT.Contact = "OverlordAkise@Steam"
ENT.Purpose = "Disguise yourself!"
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Luctus Disguise"


function ENT:Initialize()
    if CLIENT then return end

    self:SetModel( "models/props_wasteland/controlroom_storagecloset001a.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )     
    self:SetMoveType( MOVETYPE_VPHYSICS )  
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType(SIMPLE_USE)
    local p = self:GetPos()
    self:SetPos(p)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use( activator, caller )
	if activator:IsPlayer() then
        if not LUCTUS_DISGUISE_ALLOWED_JOBS[team.GetName(activator:Team())] then
            DarkRP.notify(activator,1,5,"You can't use this!")
            return
        end
        net.Start("luctus_disguise")
            net.WriteEntity(self)
        net.Send(activator)
	end
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 512) then return end
    local pos = self:GetPos() + (self:GetAngles():Forward()*15) + (self:GetAngles():Up() * 30) + (self:GetAngles():Right() *15)
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos, ang, 0.4)
    draw.SimpleTextOutlined("Disguise", "DermaLarge", 37, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,2,3,color_black)
    cam.End3D2D()
end
