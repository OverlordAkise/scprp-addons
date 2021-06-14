--Luctus Fire Extinguisher
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName= "Fire Extinguisher"
ENT.Author= "OverlordAkise"
ENT.Contact= ""
ENT.Purpose= ""
ENT.Instructions= ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Luctus"

function ENT:Initialize()
	if CLIENT then return end
  
	self:SetModel( "models/weapons/w_fire_extinguisher.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_VPHYSICS )  
	self:SetSolid( SOLID_VPHYSICS )
  
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if (activator:IsPlayer()) then
    if not activator:HasWeapon("weapon_extinguisher") then
      activator:Give("weapon_extinguisher")
    end
	end
end

if ( SERVER ) then return end

function ENT:Draw()
  self:DrawModel()
end
