--Luctus Washsaloon
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Basket (dirty)"
ENT.Category = "Washsaloon"
ENT.Author = "OverlordAkise"
ENT.Purpose = "Collect clean clothes"
ENT.Instructions = "N/A"
ENT.Model = "models/props_wasteland/laundry_cart002.mdl"

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
        if CLIENT then return end
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Use(activator, caller)
        if not IsValid(activator) or not activator:IsPlayer() then return end
        if LUCTUS_WASHSALOON_JOB_WHITELIST and not LUCTUS_WASHSALOON_JOBS[team.GetName(activator:Team())] then
            DarkRP.notify(activator,1,5,"[washsaloon] You can not use the washsaloon!")
            return
        end
        if IsValid(activator.dirtyclothes) then
            DarkRP.notify(activator,1,5,"[washsaloon] You can only take out 1 dirty cloth at a time!")
            return
        end
        local clothes = ents.Create("luctus_washsaloon_clothes")
        clothes:SetPos(self:GetPos()+Vector(0,0,30))
        clothes:SetAngles(self:GetAngles())
        clothes:Spawn()
        clothes:Activate()
        clothes.wshowner = activator
        activator.dirtyclothes = clothes
        activator:PickupObject(clothes)
    end

    function ENT:Think()end
end

if SERVER then return end

function ENT:Draw()
    self:DrawModel() 
    local pos = self:GetPos()
    if pos:Distance(LocalPlayer():GetPos()) > 256 then return end
    
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    cam.Start3D2D(pos + (ang:Up()*16)+(ang:Right()*-5),ang,0.10)
        draw.RoundedBox(100,-170,-80,400,75,Color( 0, 0, 0, 240 ))
        draw.SimpleText("Dirty clothes","luctus_washsaloon_big",30,-70,Color(255,255,255),TEXT_ALIGN_CENTER)
    cam.End3D2D() 
end
