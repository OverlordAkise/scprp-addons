--Luctus SCP457
--Made by OverlordAkise

AddCSLuaFile()

SWEP.PrintName = "SCP 457"
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "Set people aflame"
SWEP.Instructions = "Press LMB to shoot a firelaser!"
SWEP.Category = "SCP"
SWEP.Sound = "weapons/physcannon/energy_sing_explosion2.wav"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.HoldType = "normal"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
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

SWEP.IsBurning = true

function SWEP:Deploy()
    self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel() end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Holster()
    return true
end

function SWEP:CanPrimaryAttack()
    return false
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    local owner = self:GetOwner()
    self:SetNextPrimaryFire(CurTime()+LUCTUS_SCP457_IGNITE_ATTACK_DELAY)
    if SERVER and CurTime() < owner.lNoBurn then return end
    
    --Laser effect
    local effectdata = EffectData()
    effectdata:SetOrigin(owner:GetPos()+Vector(0,0,50))
    local tr = owner:GetEyeTrace()
    effectdata:SetNormal(tr.Normal)
    effectdata:SetRadius(30)
    util.Effect("AR2Explosion", effectdata)
    owner:EmitSound(self.Sound,75,100,0.10)
    
    if CLIENT then return end
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > LUCTUS_SCP457_IGNITE_ATTACK_RANGE then return end
    if not hitEnt:IsPlayer() then return end    
    hitEnt:Ignite(LUCTUS_SCP457_IGNITE_ATTACK_DURATION,LUCTUS_SCP457_IGNITE_ATTACK_BURN_RANGE)
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
    if ply:EyePos():Distance(trace.HitPos) > 128 then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if LUCTUS_SCP457_UNBREACHABLE[trace.Entity:GetName()] or LUCTUS_SCP457_UNBREACHABLE[trace.Entity:MapCreationID()] then
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
    --ply:EmitSound(self.Sound)
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav")
end

SWEP.lastReload = 0
local reload_toggle_delay = 1
function SWEP:Reload()
    if self.lastReload > CurTime() then return end
    self.lastReload = CurTime()+reload_toggle_delay
    if SERVER then
        scp457_shouldburn = not scp457_shouldburn
    else
        self.IsBurning = not self.IsBurning
        surface.PlaySound("buttons/lightswitch2.wav")
    end
end

function SWEP:DrawHUD()
    local ply = self:GetOwner()
    local scrw = ScrW()/2
    local scrh = ScrH()
    --crosshair
    draw.RoundedBox(5,scrw-1,scrh/2-1,2,2,color_white)
    local cdlmb = self:GetNextPrimaryFire()-CurTime()
    local cdrmb = self:GetNextSecondaryFire()-CurTime()
    local cdrel = self.lastReload-CurTime()
    if cdlmb > 0 and LUCTUS_SCP457_IGNITE_ATTACK_DELAY > 0.8 then
        draw.SimpleTextOutlined("(LBM) Fire-Ray", "Trebuchet24", scrw-100, scrh/1.3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+1,(cdlmb*200)/LUCTUS_SCP457_IGNITE_ATTACK_DELAY-2,24-2,color_white)
    end
    if cdrmb > 0 then
        draw.SimpleTextOutlined("(RMB) Door-Opener", "Trebuchet24", scrw-100, scrh/1.3+30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+30,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+30+1,cdrmb*200-2,24-2,color_white)
    end
    if cdrel > 0 then
        draw.SimpleTextOutlined("(Reload) Toggle-Burn", "Trebuchet24", scrw-100, scrh/1.3+60, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+60,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+60+1,(cdrel*200)/reload_toggle_delay-2,24-2,color_white)
    end
    if self.IsBurning then
        draw.SimpleTextOutlined("BURNING", "Trebuchet24", scrw,scrh/1.6,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,color_black)
    end
end
