--Luctus Funk
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName= "Decryptor"
ENT.Author= "OverlordAkise"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Funk"


function ENT:Initialize()
  self:PhysicsInit( SOLID_VPHYSICS )
  self:SetModel( "models/props_combine/combine_interface001.mdl" )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )
  local phys = self:GetPhysicsObject()
  if (phys:IsValid()) then   
    phys:Wake()
  end
end

function ENT:Use(Activator, Caller, UseType, Integer)
    net.Start("luctus_funk_opendec")
        net.WriteEntity(self)
    net.Send(Activator)
end

if SERVER then return end

surface.CreateFont( "DecoderText", { font = "Default", size = 80, weight = 500, antialias = true })
function ENT:Draw()
  self:DrawModel()

  local TextHeight = (math.sin(CurTime() * 2) * 15)

  local lpos = Vector(-5, -10.5, 120)
  local pos = self:LocalToWorld( lpos )
  local angle = self:GetAngles()
  angle:RotateAroundAxis(angle:Forward(),90)
  angle:RotateAroundAxis(angle:Right(), 270)
  cam.Start3D2D(pos, angle, 0.1)
    draw.SimpleText("Decryptor", "DecoderText" ,100,300 - TextHeight, Color(230,230,230,255),1)
  cam.End3D2D()
end
