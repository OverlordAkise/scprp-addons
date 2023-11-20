--Luctus SCP173 System
--Made by OverlordAkise

AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
DEFINE_BASECLASS("weapon_cs_base2")

SWEP.PrintName = "SCP173 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Left click to kill, right click to break open doors"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP173"
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

--SWEP.Sound = "physics/wood/wood_box_impact_hard3.wav" --currently random metal stress
SWEP.KillSound = "npc/barnacle/neck_snap2.wav"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
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

function SWEP:OpenDoor(ent,ply,trace)
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if SCP173_UNBREACHABLE[ent:GetName()] or SCP173_UNBREACHABLE[ent:MapCreationID()] then
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
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav",100,100,0.5)
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    local owner = self:GetOwner()
    local tr = owner:GetEyeTrace()
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > 256 then return end
    if hitEnt:isDoor() then
        if SERVER then
            self:OpenDoor(hitEnt,owner,tr)
        end
        self:SetNextPrimaryFire(CurTime() + SCP173_PRIMARY_DELAY)
        return
    end
    -- effect
    if hitEnt:IsPlayer() then
        local edata = EffectData()
        edata:SetStart(owner:GetShootPos())
        edata:SetOrigin(tr.HitPos)
        edata:SetNormal(tr.Normal)
        edata:SetEntity(hitEnt)
        util.Effect("BloodImpact", edata)
        if SERVER then
            hitEnt:TakeDamage(99997, owner, self)
            ply:EmitSound(self.KillSound)
        end
    end
    self:SetNextPrimaryFire(CurTime() + SCP173_PRIMARY_DELAY)
end

function SWEP:SecondaryAttack()
    --For calling from outside: Do not fire if not ready yet
    if self:GetNextSecondaryFire() > CurTime() then return end
    self:SetNextSecondaryFire(CurTime() + SCP173_SECONDARY_DELAY)
    if CLIENT then return end
    local owner = self:GetOwner()
    owner:EmitSound(SCP173_SECONDARY_SOUND)
    for k,ply in ipairs(ents.FindInSphere(owner:GetPos(),256)) do
        if not ply:IsPlayer() then continue end
        if ply == owner then continue end
        LuctusSCP173Blink(ply,SCP173_SECONDARY_BLINKTIME)
    end
end


function SWEP:DrawHUD()
    local ply = self:GetOwner()
    local scrw = ScrW()
    local scrh = ScrH()
    --crosshair
    draw.RoundedBox(5,scrw/2-1,scrh/2-1,2,2,color_white)
    local cdlmb = self:GetNextPrimaryFire()-CurTime()
    local cdrmb = self:GetNextSecondaryFire()-CurTime()
    if cdlmb > 0 and SCP173_PRIMARY_DELAY > 0.8 then
        draw.SimpleTextOutlined("Kill Cooldown", "Trebuchet24", scrw/2-100, scrh/1.3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw/2-95,scrh/1.3,200,24,color_black)
        draw.RoundedBox(0,scrw/2-95,scrh/1.3,(cdlmb*200)/SCP173_PRIMARY_DELAY,24,color_white)
    end
    if cdrmb > 0 and SCP173_SECONDARY_DELAY > 0.9 then
        draw.SimpleTextOutlined("Force-Blink Cooldown", "Trebuchet24", scrw/2-100, scrh/1.3+30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw/2-95,scrh/1.3+30,200,24,color_black)
        draw.RoundedBox(0,scrw/2-95+1,scrh/1.3+30+1,(cdrmb*200)/SCP173_SECONDARY_DELAY-2,24-2,color_white)
    end
    if ply:IsFlagSet(FL_FROZEN) then
        draw.SimpleTextOutlined("SEEN", "Trebuchet24", scrw/2,scrh/1.8,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,color_black)
    end
end

