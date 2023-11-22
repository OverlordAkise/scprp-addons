--Luctus SCP049
--Made by OverlordAkise

AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.PrintName = "SCP049 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Left click to kill, right click to break open doors"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP049"
SWEP.IsDarkRPDoorRam = true

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.AnimPrefix = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "SCP"

SWEP.Sound = "ambient/materials/metal_big_impact_scrape1.wav"
SWEP.KillSound = "player/pl_pain7.wav"

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    local Owner = self:GetOwner()
    if not IsValid(Owner) then return end
    self:SetNextPrimaryFire(CurTime() + 0.1)
    if SERVER then return end
    LuctusSCP049OpenMixMenu()
end

function SWEP:TouchKill(owner,target,tr)
    if LUCTUS_SCP049_SAVE_PMODELS[target:GetModel()] then return end
    local edata = EffectData()
    edata:SetStart(owner:GetShootPos())
    edata:SetOrigin(tr.HitPos)
    edata:SetNormal(tr.Normal)
    edata:SetEntity(target)
    util.Effect("BloodImpact", edata)
    if CLIENT then return end
    target:TakeDamage(99996, owner, self)
    owner:EmitSound(self.KillSound)
end

function SWEP:OpenDoor(ply,ent,trace)
    if CLIENT then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if LUCTUS_SCP049_UNBREACHABLE[trace.Entity:GetName()] or LUCTUS_SCP049_UNBREACHABLE[trace.Entity:MapCreationID()] then
        DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
        return false
    end
    
    --SCP doors:
    if ent:GetClass() == "prop_dynamic" and ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
        ent = ent:GetParent()
    end
    ent:keysUnLock()
    ent:Fire("open", "", 3)
    ent:Fire("setanimation", "open", 3)
    
    hook.Run("onDoorRamUsed", true, ply, trace)
    ply:EmitSound(self.Sound)
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    self:SetNextPrimaryFire(CurTime()+0.2)
    local ply = self:GetOwner()
    local trace = ply:GetEyeTrace()
    if ply:EyePos():Distance(trace.HitPos) > 256 then return end
    local ent = trace.Entity
    if not IsValid(ent) then return end
    
    --Kill Player
    if ent:IsPlayer() and ent:Alive() then
        self:TouchKill(ply,ent,trace)
        return
    end
    --Open Door
    if ent:isDoor() then
        self:OpenDoor(ply,ent,trace)
        return
    end
    --Zombify
    if ent:GetClass() == "prop_ragdoll" and SERVER then
        if not ply.scp049_col_one or not ply.scp049_col_two then return end
        local deadPlayer = ent:GetRagdollOwner()
        --if gDeathsystem:
        if MedConfig then
            local ragdoll = ent
            for k,v in ipairs(player.GetAll()) do
                if v:GetNW2Entity("RagdollEntity",nil) == ragdoll then
                    deadPlayer = v
                end
            end
        end
        --if advanced medic mod
        if not IsValid(deadPlayer) then
            deadPlayer = ent:GetOwner()
        end
        local mixName = scp049_mixtable[ply.scp049_col_one][ply.scp049_col_two]
        local mixedFunc = scp049_effect_functions[mixName]
        ply:PrintMessage(HUD_PRINTTALK, "Your mixture was '"..mixName.."'")
        LuctusSCP049SpawnZombie(mixedFunc,deadPlayer,mixName,ply,trace.HitPos)
    end
end
