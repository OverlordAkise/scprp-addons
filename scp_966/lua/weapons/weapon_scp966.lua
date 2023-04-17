AddCSLuaFile()

SWEP.PrintName = "SCP 966"
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "Slowly kill people"
SWEP.Category = "SCP"
SWEP.Instructions = "LMB to eat sleeping people, Stare at people to make them sleep"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Delay = 2
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "None"
SWEP.Weight = 3
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.UseHands = false

SWEP.HoldType = "normal"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.AdminSpawnable = false

LuctusLog = LuctusLog or function()end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:PrimaryAttack()
    local owner = self.Owner
    tr = {}
    tr.start = owner:GetShootPos()
    tr.endpos = owner:GetShootPos() + ( owner:GetAimVector() * 95 )
    tr.filter = owner
    tr.mask = MASK_SHOT
    trace = util.TraceLine(tr)
    if trace.Hit and trace.Entity and trace.Entity:GetClass() == "prop_ragdoll" and trace.Entity:CPPIGetOwner() and trace.Entity:GetPos():Distance(owner:GetPos()) < 512 then
        if trace.Entity.scp966_skelhit then return end
        trace.Entity.scp966_skelhit = true
        local ply,pid = trace.Entity:CPPIGetOwner()
        if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
        
        for i=1,5 do
            util.Decal("Blood", owner:EyePos(), owner:EyePos() + owner:EyeAngles():Forward()*500 + Vector(math.Rand(1,50),math.Rand(1,50),math.Rand(1,50)),trace.Entity)
        end
        trace.Entity:SetModel("models/player/skeleton.mdl")
        if CLIENT then return end
        owner:EmitSound("npc/barnacle/neck_snap2.wav", 100, 100)
        owner:SetHealth(math.min(owner:GetMaxHealth(),owner:Health()+LUCTUS_SCP966_HPGAINED))
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        trace.Entity:TakeDamage(99998, self.Owner, self)
        LuctusLog("scp",owner:Nick().."("..owner:SteamID()..") as SCP966 ate "..ply:Nick().."("..ply:SteamID()..")")
    end
    if SERVER and trace.Hit and trace.Entity and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
        local ply = trace.Entity
        if ply:GetWalkSpeed() > LUCTUS_SCP966_WALKSPEEDNEEDED then return end
        if LUCTUS_SCP966_GDEATHSYSTEM then
            ply:TakeDamage(99999, owner, self)
        else
            DarkRP.toggleSleep(ply, "force")
        end
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        LuctusLog("scp",owner:Nick().."("..owner:SteamID()..") as SCP966 sleep'd "..ply:Nick().."("..ply:SteamID()..")")
    end
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextSecondaryFire(CurTime() + 1)
    if CLIENT then return end
    local ply = self:GetOwner()
    if not IsValid(ply) then return end
    local trace = ply:GetEyeTrace()
    local ent = trace.Entity
    if not IsValid(ent) then return end
    if not ent:isDoor() then return end
    if ply:EyePos():Distance(trace.HitPos) > 512 then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if SCP966_UNBREACHABLE[ent:GetName()] or SCP966_UNBREACHABLE[ent:MapCreationID()] then
        DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
        return false
    end
    
    --SCP doors:
    if ent:GetClass() == "prop_dynamic" and ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
        ent = ent:GetParent()
    end
    ent:keysUnLock()
    ent:Fire("open", "", .6)
    ent:Fire("setanimation", "open", .6)
    
    hook.Run("onDoorRamUsed", true, ply, trace)
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav")
end

if CLIENT then return end
function SWEP:Think()
    local owner = self.Owner
    if not IsValid(owner) then return end
    local tr = owner:GetEyeTrace()
    if tr.Hit and tr.Entity and tr.Entity:IsPlayer() and tr.Entity:Alive() then 
        local ply = tr.Entity
        if not ply.loldWalkSpeed then ply.loldWalkSpeed = ply:GetWalkSpeed() end
        if not ply.loldRunSpeed then ply.loldRunSpeed = ply:GetRunSpeed() end
        ply:SetWalkSpeed(ply:GetWalkSpeed() - ply.loldWalkSpeed/600)
        ply:SetRunSpeed(ply:GetRunSpeed() - ply.loldRunSpeed/600)
    end
    self:NextThink(CurTime() + 0.2)
end

