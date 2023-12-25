--Luctus Washsaloon
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Collector (clean)"
ENT.Category = "Washsaloon"
ENT.Author = "OverlordAkise"
ENT.Purpose = "Collect clean clothes"
ENT.Instructions = "N/A"
ENT.Model = "models/props_wasteland/laundry_cart001.mdl"

ENT.Spawnable = true
ENT.AdminSpawnable = false

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Use(activator,caller)
        if not IsValid(activator) or not activator:IsPlayer() then return end
        DarkRP.notify(activator,0,5,"[washsaloon] Put your clean, white clothes in here")
    end

    function ENT:Think() end

    function ENT:StartTouch(entity)
        if entity:GetClass() ~= "luctus_washsaloon_clothes" then return end
        --if self:GetWashStartTime() ~= 0 then return end
        if not entity.clean then return end
        if not entity.wshowner or not IsValid(entity.wshowner) then return end
        --Start work
        local ply = entity.wshowner
        entity:Remove()
        hook.Run("LuctusWashsaloonHandinClean",ply)
        ply:addMoney(LUCTUS_WASHSALOON_REWARD_MONEY)
        DarkRP.notify(ply,0,3,"$+"..LUCTUS_WASHSALOON_REWARD_MONEY)
    end
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel() 
    local pos = self:GetPos()
    if pos:Distance(LocalPlayer():GetPos()) > 256 then return end
    
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos + (ang:Up()*24)+(ang:Right()*-5),ang,0.10)
        draw.RoundedBox(0,-300,-130,600,75,Color( 0, 0, 0, 240 ))
        draw.SimpleText("Clean clothes collector","luctus_washsaloon_big",0,-120,Color(255,255,255),TEXT_ALIGN_CENTER)
    cam.End3D2D() 
end
