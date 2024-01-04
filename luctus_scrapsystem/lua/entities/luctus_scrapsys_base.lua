--Luctus Scrapsys
--Made by OverlordAkise

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Name = "Scrap Base"
ENT.PrintName = "Scrap"
ENT.Author = "OverlordAkise"
ENT.Category = "Scrapsystem"
ENT.Purpose = "Earn scrap"
ENT.Instructions = "Press E to loot for scrap"

ENT.Freeze = true
ENT.Spawnable = false
ENT.AdminSpawnable = false

--sane defaults
ENT.Lootable = true
ENT.Model = "models/props_junk/garbage128_composite001a.mdl"
ENT.scrapmin = 1
ENT.scrapmax = 1
ENT.getmin = 1
ENT.getmax = 1
ENT.invis = true
ENT.hascollision = false


if CLIENT then return end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
    self.scrapLeft = math.random(self.getmin,self.getmax)
    if not self.hascollision then
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end
end

function ENT:Use(ply, caller)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if LUCTUS_SCRAPSYS_JOBWHITELIST and not LUCTUS_SCRAPSYS_JOBNAMES[team.GetName(ply:Team())] then return end
    if not self.Lootable then return end
    
    self.scrapLeft = self.scrapLeft - 1
    local scrapToGet = math.random(self.scrapmin,self.scrapmax)
    local mul = hook.Run("LuctusScrapsysMultiplier",self,ply)
    if tonumber(mul) then
        scrapToGet = math.ceil(scrapToGet*tonumber(mul))
    end
    LuctusScrapsysAdd(ply,scrapToGet)
    if self.scrapLeft <= 0 then
        self.Lootable = false
        timer.Simple(LUCTUS_SCRAPSYS_RECHARGE_DELAY,function()
            if not IsValid(self) then return end
            self.Lootable = true
            self.scrapLeft = math.random(self.getmin,self.getmax)
            if self.invis then
                self:SetNoDraw(false)
            end
        end)
        if self.invis then
            self:SetNoDraw(true)
        end
    end
end

function ENT:Think() end
function ENT:OnTakeDamage() end
