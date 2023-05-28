--Citizenizer NPC
--Made by OverlordAkise

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName= "Surface Citizenizer NPC"
ENT.Author= "OverlordAkise"
ENT.Contact= ""
ENT.Purpose= ""
ENT.Instructions= ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "SCP"
ENT.Model = "models/Humans/Group01/male_08.mdl"


if SERVER then
    
    hook.Add("PostPlayerDeath","luctus_citizenizer",function(ply)
        if ply.citizenized then
            ply.citizenized = false
            if ply:Team() != TEAM_CITIZEN then return end
            DarkRP.notify(ply,1,5,"You died and got removed from your job!")
            ply:changeTeam(GAMEMODE.DefaultTeam,true)
        end
    end)
    
    function ENT:Use(ply, caller, useType, value)
        if ply.citizenized then return end
        ply.citizenized = true
        ply:changeTeam(TEAM_CITIZEN,true)
    end

    function ENT:Initialize()
        self:SetModel(self.Model)
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
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel()
    if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
        local a = Angle(0,0,0)
        a:RotateAroundAxis(Vector(1,0,0),90)
        a.y = LocalPlayer():GetAngles().y - 90
        cam.Start3D2D(self:GetPos() + Vector(0,0,80), a , 0.074)
            draw.RoundedBox(8,-225,-75,450,75 , Color(45,45,45,255))
            local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
            surface.SetDrawColor(Color(45,45,45,255))
            draw.NoTexture()
            surface.DrawPoly( tri )

            draw.SimpleText(self.PrintName,"DermaLarge",0,-40,Color(255,255,255,255) , 1 , 1)
        cam.End3D2D()
    end
end
