--Luctus Cleaner
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Name = "Trash"
ENT.PrintName = "Trash (Use Spawner)"
ENT.Author = "OverlordAkise"
ENT.Category = "Cleaner"
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Model = "models/props/cs_office/trash_can_p7.mdl"
ENT.RandomModels = {
    --"models/props_junk/garbage_carboard002a.mdl",
    --"models/props_junk/garbage_bag001a.mdl",
    
    "models/props/cs_office/trash_can_p7.mdl",
    "models/props_junk/garbage_glassbottle003a.mdl",
    "models/props_junk/garbage_metalcan002a.mdl",
    "models/props_junk/garbage_takeoutcarton001a.mdl",
    "models/props_junk/PopCan01a.mdl",
    "models/props_lab/box01b.mdl",
}

ENT.Freeze = true
ENT.Spawnable = true
ENT.AdminSpawnable = true

if CLIENT then return end

function ENT:Initialize()
    self:SetModel(self.RandomModels[math.random(#self.RandomModels)])
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if SERVER then self:PhysicsInit(SOLID_VPHYSICS) end
    self:PhysWake()
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    timer.Simple(0.5,function()
        if not IsValid(self) then return end
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Sleep()
        end
    end)
    self.IsHidden = false
    if math.random(1,100) > 33 then
        self:LuctusDespawn()
    end
end

function ENT:LuctusSpawn()
    self:SetModel(self.RandomModels[math.random(#self.RandomModels)])
    self:SetNoDraw(false)
    self.IsHidden = false
end

function ENT:LuctusDespawn()
    self:SetNoDraw(true)
    self.IsHidden = true
    local rd = LUCTUS_CLEANER_RESPAWN_DELAY
    timer.Simple(math.random(rd*0.5,rd*2),function()
        if not IsValid(self) then return end
        self:LuctusSpawn()
    end)
end

function ENT:Think() end
