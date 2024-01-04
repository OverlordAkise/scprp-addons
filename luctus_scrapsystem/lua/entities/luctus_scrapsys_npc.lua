--Luctus Scrapsys
--Made by OverlordAkise

AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName= "Scrap NPC"
ENT.Author= "OverlordAkise"
ENT.Contact= "OverlordAkise @steam"
ENT.Purpose= "Craft things with scrap"
ENT.Instructions= "Press E to craft"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Scrapsystem"

ENT.SellTable = {}

function ENT:Initialize()
    if CLIENT then return end

    self:SetModel("models/Eli.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetBloodColor(BLOOD_COLOR_RED)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    net.Start("luctus_scrapsys_craft")
        net.WriteEntity(self)
    net.Send(activator)
end

if SERVER then return end

local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
local color_bg = Color(45,45,45,255)
local color_white = Color(255,255,255,255)
function ENT:Draw()
    self:DrawModel()
    if (self:GetPos():Distance(LocalPlayer():GetPos()) > 300) then return end
    local a = Angle(0,0,0)
    a:RotateAroundAxis(Vector(1,0,0),90)
    a.y = LocalPlayer():GetAngles().y - 90
    cam.Start3D2D(self:GetPos() + Vector(0,0,75), a , 0.074)
        draw.RoundedBox(8,-105,-75,210,75,color_bg)
        surface.SetDrawColor(color_bg)
        draw.NoTexture()
        surface.DrawPoly(tri)
        draw.SimpleText("Scrap NPC","DermaLarge",0,-40,color_white,1,1)
    cam.End3D2D()
end
