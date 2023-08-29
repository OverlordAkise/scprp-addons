--Luctus Exam
--Made by OverlordAkise

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName= "CT PVT Trainer"
ENT.OverheadText = "CT PVT Exam NPC"
ENT.Author= "OverlordAkise"
ENT.Contact= ""
ENT.Purpose= ""
ENT.Instructions= ""
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Exam NPCs"
ENT.Model = "models/odessa.mdl"
ENT.AllowedMistakes = 1
ENT.TimeBetweenExams = 60

function ENT:SuccessFunction(ply)
    error("exam base was called, No SuccessFunction defined!")
end

function ENT:CanTakeExam(ply)
    return true
end

ENT.Questions = {
  --[x] = {Correct_Answer_Index, Question, Ans#1, Ans#2, Ans#3, Image_Link},
    [0] = {1,"You shouldnt be here","stop","","",nil},
}

if SERVER then
    function ENT:Use(ply)
        if ply[self:GetClass()] and ply[self:GetClass()] > CurTime() then
            DarkRP.notify(ply,0,5,"You have to wait "..string.NiceTime(ply[self:GetClass()]-CurTime()).." before taking the exam again!")
            return
        end
        local canAttend, reason = self:CanTakeExam(ply)
        if not canAttend then
            DarkRP.notify(ply,0,5,reason)
            return
        end
        net.Start("luctus_exam")
            net.WriteEntity(self)
            net.WriteTable(self.Questions)
        net.Send(ply)
        ply.examTimeStart = CurTime()
    end

    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetNPCState(NPC_STATE_SCRIPT)
        self:SetBloodColor(BLOOD_COLOR_RED)
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)

        local p = self:GetPos()
        self:SetPos(p)

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end
end

if SERVER then return end

local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
local color_bg = Color(45,45,45,255)
local color_text = Color(255,255,255,255)

function ENT:Draw()
    self:DrawModel()
    if LocalPlayer():GetPos():Distance(self:GetPos()) > 550 then return end
    local a = Angle(0,0,0)
    a:RotateAroundAxis(Vector(1,0,0),90)
    a.y = LocalPlayer():GetAngles().y - 90
    cam.Start3D2D(self:GetPos() + Vector(0,0,80), a , 0.074)
        draw.RoundedBox(8,-225,-75,450,75 , color_bg)
        surface.SetDrawColor(color_bg)
        draw.NoTexture()
        surface.DrawPoly(tri)
        draw.SimpleText(self.PrintName, "DermaLarge", 0, -37, color_text, 1, 1)
    cam.End3D2D()
end
