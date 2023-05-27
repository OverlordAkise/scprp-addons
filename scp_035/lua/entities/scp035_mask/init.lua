AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
    --Vars
    self.isTaken = false
end
 
function ENT:Use( activator, caller, usetype )
    if activator:IsPlayer() then
        if self.isTaken then return end
        self.isTaken = true
        DarkRP.notify(activator, 3, 5, "You put on the mask and became SCP 035!")
        activator:SetNWBool("isSCP035",true)
        activator.loldJobName = activator:getDarkRPVar("job")
        activator:setDarkRPVar("job","SCP 035")
        self:Remove()
    end
end
