--Luctus Backpack
--Made by OverlordAkise

AddCSLuaFile()

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.PrintName = "Jobrucksack"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
 
SWEP.Author = "OverlordAkise"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "LMB to open"
SWEP.Category = "Jobbackpack"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.SpawnPos = nil
SWEP.SpawnAngle = nil
SWEP.EntConsole = nil
SWEP.ClCarEnt = nil
 
function SWEP:Reload() end

function SWEP:Think() end

function SWEP:Deploy()
    self:SetHoldType("normal")
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
    if not IsFirstTimePredicted() then return end
    if CLIENT then
        if IsValid(LBACKMENU) then return end
        LuctusOpenJobBackpackMenu()
    end
end

function SWEP:SecondaryAttack() end
