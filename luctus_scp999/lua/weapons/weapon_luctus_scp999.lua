--Luctus SCP999
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

SWEP.PrintName = "SCP999 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "LMB to heal one, RMB to heal in area, Reload to make a sound"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP999"
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

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    self:SetNextPrimaryFire(CurTime()+LUCTUS_SCP999_PRIMARY_HEAL_CD)
    if CLIENT then return end
    local trace = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + (owner:GetAimVector() * 95),
        filter = owner,
        mask = MASK_SHOT,
    })

    if not trace.Hit or not IsValid(trace.Entity) or not trace.Entity:IsPlayer() then return end
    local ply = trace.Entity
    ply:SetHealth(math.min(ply:Health()+LUCTUS_SCP999_PRIMARY_HEAL,ply:GetMaxHealth()))
    net.Start("luctus_scp999_hearts")
        net.WriteEntity(owner)
    net.Broadcast()
    owner:EmitSound("scp999/scp999_"..math.random(1,6)..".mp3")
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime()+LUCTUS_SCP999_SPECIAL_HEAL_CD)
    self:EmitSound("scp999/scp999_"..math.random(1,6)..".mp3")
    for k,ply in ipairs(ents.FindInSphere(self:GetOwner():GetPos(), LUCTUS_SCP999_SPECIAL_HEAL_RANGE)) do
        if ply:IsPlayer() then
            ply:SetHealth(math.min(ply:Health()+LUCTUS_SCP999_SPECIAL_HEAL,ply:GetMaxHealth()))
        end
    end
end

SWEP.lastReload = 0
function SWEP:SecondaryAttack()
    if self.lastReload > CurTime() then return end
    self.lastReload = CurTime()+1
    self:EmitSound("scp999/scp999_"..math.random(1,6)..".mp3")
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
    if cdlmb > 0 then
        draw.SimpleTextOutlined("(LMB) Heal", "Trebuchet24", scrw-100, scrh/1.3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,200,24,color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,(cdlmb*200)/LUCTUS_SCP939_ATTACKDELAY,24,color_white)
    end
    if cdrmb > 0 then
        draw.SimpleTextOutlined("(RMB) AoE Heal", "Trebuchet24", scrw-100, scrh/1.3+30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+30,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+30+1,(cdrmb*200)/LUCTUS_SCP939_SCREAM_SEARCH_DELAY-2,24-2,color_white)
    end
    if cdrel > 0 then
        draw.SimpleTextOutlined("(Reload) Purrrr", "Trebuchet24", scrw-100, scrh/1.3+60, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+60,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+60+1,(cdrel*200)/LUCTUS_SCP939_SCREAM_BRIGHT_DELAY-2,24-2,color_white)
    end
end
