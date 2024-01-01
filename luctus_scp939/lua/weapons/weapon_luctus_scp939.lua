--Luctus SCP939
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

SWEP.PrintName = "SCP939 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Left click to damage and open doors, right click to scream, Reload to sniff out enemies"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP939"
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
    
    if LUCTUS_SCP939_UNBREACHABLE[ent:GetName()] or LUCTUS_SCP939_UNBREACHABLE[ent:MapCreationID()] then
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
    ply:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav",100,100,0.5)
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    owner:SetAnimation( PLAYER_ATTACK1 )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:SetNextPrimaryFire(CurTime() + LUCTUS_SCP939_ATTACKDELAY)
    self:EmitSound("npc/headcrab/attack1.wav",75,50) --npc/fast_zombie/wake1.wav
    local tr = owner:GetEyeTrace()
    local hitEnt = tr.Entity
    if not IsValid(hitEnt) then return end
    if owner:GetPos():Distance(hitEnt:GetPos()) > LUCTUS_SCP939_ATTACKRANGE then return end
    if hitEnt:isDoor() then
        if SERVER then
            self:OpenDoor(hitEnt,owner,tr)
        end
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
            hitEnt:TakeDamage(LUCTUS_SCP939_DAMAGE, owner, self)
        else--CLIENT
            LuctusSCP939AddVisiblePlayer(hitEnt,0.3)
        end
    end
end

function SWEP:SecondaryAttack()
    if not IsValid(self:GetOwner()) then return end
    self:SetNextSecondaryFire(CurTime()+LUCTUS_SCP939_SCREAM_SEARCH_DELAY)
    self:EmitSound("npc/fast_zombie/fz_alert_far1.wav",SNDLVL_100dB,50)
    if SERVER then return end
    LuctusSCP939HighlightClose()
end

SWEP.lastReload = 0
function SWEP:Reload()
    if self.lastReload > CurTime() then return end
    self.lastReload = CurTime()+LUCTUS_SCP939_SCREAM_BRIGHT_DELAY
    self:EmitSound("npc/fast_zombie/fz_alert_close1.wav",75,50)
    if SERVER then return end
    LuctusSCP939MakeBright()
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
    if cdlmb > 0 and LUCTUS_SCP939_ATTACKDELAY > 0.8 then
        draw.SimpleTextOutlined("(LMB) Attack/Doors", "Trebuchet24", scrw-100, scrh/1.3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,200,24,color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,(cdlmb*200)/LUCTUS_SCP939_ATTACKDELAY,24,color_white)
    end
    if cdrmb > 0 and LUCTUS_SCP939_SCREAM_BRIGHT_DELAY > 0.9 then
        draw.SimpleTextOutlined("(RMB) Detect-Close", "Trebuchet24", scrw-100, scrh/1.3+30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+30,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+30+1,(cdrmb*200)/LUCTUS_SCP939_SCREAM_SEARCH_DELAY-2,24-2,color_white)
    end
    if cdrel > 0 then
        draw.SimpleTextOutlined("(Reload) Scream", "Trebuchet24", scrw-100, scrh/1.3+60, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+60,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+60+1,(cdrel*200)/LUCTUS_SCP939_SCREAM_BRIGHT_DELAY-2,24-2,color_white)
    end
end
