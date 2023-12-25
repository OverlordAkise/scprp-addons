--Luctus Washsaloon
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Washing Machine"
ENT.Category = "Washsaloon"
ENT.Author = "OverlordAkise"
ENT.Purpose = "Make dirty clothes wet and clean"
ENT.Instructions = "Put brown shirt in, get blue shirt out"
ENT.Model = "models/props_c17/furniturewashingmachine001a.mdl"

ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "WashStartTime")
    self:NetworkVar("String", 2, "WshOwner")
end

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller) end

    function ENT:Think() end

    function ENT:StartTouch(entity)
        if entity:GetClass() ~= "luctus_washsaloon_clothes" then return end
        if self:GetWashStartTime() ~= 0 then return end
        if entity.wet then return end
        if entity.clean then return end
        if not entity.wshowner or not IsValid(entity.wshowner) then return end
        --Start work
        
        self.wshowner = entity.wshowner
        self:SetWshOwner(entity.wshowner:Nick())
        entity:Remove()
        self:SetWashStartTime(os.time())
        timer.Simple(LUCTUS_WASHSALOON_WSHMCH_DURATION,function()
            if not IsValid(self) then return end
            self:SetWashStartTime(0)
            if not IsValid(self.wshowner) then return end
            local clothes = ents.Create("luctus_washsaloon_clothes")
            clothes:SetPos(self:GetPos()+Vector(0,0,30))
            clothes:SetAngles(self:GetAngles())
            clothes:Spawn()
            clothes:Activate()
            clothes.wet = true
            clothes.wshowner = self.wshowner
            timer.Simple(0.1,function()
                if not IsValid(clothes) then return end
                clothes:SetColor(Color(15,37,237,255))
            end)
        end)
    end
end




if SERVER then return end

function ENT:OnRemove()
    self:StopSound("ambient/machines/engine1.wav")
end

function ENT:Draw()
    self:DrawModel() 
    local Pos = self:GetPos()
    local dist = Pos:DistToSqr(LocalPlayer():GetPos())
    if (dist > 400*400) then return end
    
    local Ang = self:GetAngles()
    local washStartTime = self:GetWashStartTime()

    Ang:RotateAroundAxis(Ang:Right(),-65)
    Ang:RotateAroundAxis(Ang:Up(),90)
    cam.Start3D2D(Pos + (Ang:Up()*-0.6)+(Ang:Right()*-11),Ang,0.10)
        draw.RoundedBox(0,-130,-130,260,55,Color( 0, 0, 0, 240 ))
        if washStartTime > 0 then
            
            local current = ((os.time()-washStartTime)*100)/LUCTUS_WASHSALOON_WSHMCH_DURATION
            self.tt = (current * 252)/100
            if self.tt < 254 and not self.Sound then
                self.Sound = true
                self:EmitSound("ambient/machines/engine1.wav", 75, 100, 0.2, CHAN_AUTO)
            end
            draw.RoundedBox(0,-126,-126,self.tt,47,Color(0,250,0,255))
            draw.SimpleTextOutlined(self:GetWshOwner() or "<nobody>","luctus_washsaloon_small",0,-120,Color(255,255,255),TEXT_ALIGN_CENTER,0,2,Color(0,0,0,255))
        else
            draw.SimpleTextOutlined("Ready to wash!","luctus_washsaloon_small",0,-120,Color(255,255,255),TEXT_ALIGN_CENTER,0,2,Color(0,0,0,255))
            if self.Sound then 
                self.Sound = false
                self:StopSound("ambient/machines/engine1.wav")
                self:EmitSound("items/ammocrate_open.wav",75,100,0.7,CHAN_AUTO)
            end
        end
    cam.End3D2D() 
end
