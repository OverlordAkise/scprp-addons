--Luctus SCP682
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

SWEP.PrintName = "SCP682 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Leftclick to damage, Rightclick to open doors, Reload to sprint a short distance"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP682"
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

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


function SWEP:Initialize()
    self:SetHoldType("melee")
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
    
    if LUCTUS_SCP682_UNBREACHABLE[ent:GetName()] or LUCTUS_SCP682_UNBREACHABLE[ent:MapCreationID()] then
        DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
        return false
    end
    --SCP doors:
    if ent:GetClass() == "prop_dynamic" and ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
        ent = ent:GetParent()
    end
    
    ent:keysUnLock()
    ent:Fire("open", "", .01)
    ent:Fire("setanimation", "open", .01)
    
    hook.Run("onDoorRamUsed", true, ply, trace)
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav",100,100,0.5)
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    owner:SetAnimation( PLAYER_ATTACK1 )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:SetNextPrimaryFire(CurTime() + LUCTUS_SCP682_ATTACKDELAY)
    self:EmitSound("npc/headcrab/headbite.wav",40,50)
    local tr = owner:GetEyeTrace()
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > 256 then return end
    if not hitEnt:IsPlayer() then return end
    
    local edata = EffectData()
    edata:SetStart(owner:GetShootPos())
    edata:SetOrigin(tr.HitPos)
    edata:SetNormal(tr.Normal)
    edata:SetEntity(hitEnt)
    util.Effect("BloodImpact", edata)
    
    if SERVER then
        hitEnt:TakeDamage(LUCTUS_SCP682_DAMAGE, owner, self)
    end
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    owner:SetAnimation( PLAYER_ATTACK1 )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:SetNextSecondaryFire(CurTime() + LUCTUS_SCP682_ATTACKDELAY)
    self:EmitSound("npc/headcrab/attack1.wav",75,20)
    if CLIENT then return end
    
    local tr = owner:GetEyeTrace()
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > 256 then return end
    if not hitEnt:isDoor() then return end

    self:OpenDoor(hitEnt,owner,tr)
end

SWEP.lastReload = 0
function SWEP:Reload()
    if self.lastReload > CurTime() then return end
    self.lastReload = CurTime()+LUCTUS_SCP682_SPECIAL_JUMP_DELAY
    self:EmitSound("npc/ichthyosaur/attack_growl1.wav",75)
    if CLIENT then return end
    local ply = self:GetOwner()
    local dir = ply:GetAimVector()
    dir.z = 0.5
    ply:SetVelocity(dir*LUCTUS_SCP682_SPECIAL_JUMP_STRENGTH)
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
    if cdlmb > 0 and LUCTUS_SCP682_ATTACKDELAY > 0.8 then
        draw.SimpleTextOutlined("(LMB) Attack", "Trebuchet24", scrw-100, scrh/1.3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+1,(cdlmb*200)/LUCTUS_SCP682_ATTACKDELAY-2,24-2,color_white)
    end
    if cdrmb > 0 and LUCTUS_SCP682_ATTACKDELAY > 0.8 then
        draw.SimpleTextOutlined("(RMB) Door-Opener", "Trebuchet24", scrw-100, scrh/1.3+30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+30,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+30+1,(cdrmb*200)/LUCTUS_SCP682_ATTACKDELAY-2,24-2,color_white)
    end
    if cdrel > 0 then
        draw.SimpleTextOutlined("(Reload) Jump", "Trebuchet24", scrw-100, scrh/1.3+60, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+60,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+60+1,(cdrel*200)/LUCTUS_SCP682_SPECIAL_JUMP_DELAY-2,24-2,color_white)
    end
end
