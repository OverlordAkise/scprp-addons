--Luctus SCP066
--Made by OverlordAkise

AddCSLuaFile()

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Delay = 2
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "None"
SWEP.Weight = 3
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.UseHands = false
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "SCPRP Job SCP066"
SWEP.Category = "SCP"
SWEP.Instructions = "LMB Eric, RMB Damage, R random sound"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.PrintName = "SCP 066"
SWEP.HoldType = "normal"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.nextThink = 0
SWEP.nextReload = 0

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
    if self.isPlaying then
        self.isPlaying = false
        self:StopSound("066/beethoven.wav")
    end
    return true
end

function SWEP:PrimaryAttack()
    if self.isPlaying then return end
    self:EmitSound("066/notes1.wav")
    self:SetNextPrimaryFire(CurTime()+0.5)
end

function SWEP:SecondaryAttack()
    if not self.isPlaying then
        self.isPlaying = true
        self:EmitSound("066/beethoven.wav")
        self:SetNextSecondaryFire(CurTime()+0.1)
    else
        self.isPlaying = false
        self:StopSound("066/beethoven.wav")
        self:SetNextSecondaryFire(CurTime()+0.5)
    end
end

function SWEP:Reload()
    if self.isPlaying then return end
    if self.nextReload < CurTime() then
        self:EmitSound("066/notes"..math.random(2,3)..".wav")
        self.nextReload = CurTime()+0.5
    end
end

if CLIENT then return end

function SWEP:Think()
    if self.isPlaying and self.nextThink < CurTime() then
        self.nextThink = CurTime()+0.5
        local _ents = ents.FindInSphere(self:GetOwner():GetPos(), 512)
        local plys = {}
        for i=1,#_ents do
            if _ents[i]:IsPlayer() and self:GetOwner():IsLineOfSightClear(_ents[i]) and _ents[i] ~= self:GetOwner() then
                _ents[i]:TakeDamage(5,self:GetOwner(),self)
            end
        end
    end
end
