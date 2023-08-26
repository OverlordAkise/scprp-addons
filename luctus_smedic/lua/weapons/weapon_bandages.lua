--Luctus Medic (SCP)
--Made by OverlordAkise

AddCSLuaFile()
SWEP.PrintName = "Bandages"
SWEP.Category = "Medic"
SWEP.Instructions = "Left click heal"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV = 50

if CLIENT then
    language.Add("ammo_bandage_ammo", "Bandages")
end

SWEP.Primary.Ammo = "ammo_bandage"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = -1

SWEP.PrintName = "Bandages"
SWEP.ViewModel = "models/weapons/c_bandage.mdl"
SWEP.WorldModel = "models/weapons/c_bandage.mdl"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "Charge")
end

sound.Add({
    name = "flesh_scrapple",
    channel = CHAN_STATIC,
    sound = "physics/flesh/flesh_scrape_rough_loop.wav"
})
game.AddAmmoType({
    name = "ammo_bandage",
    maxcarry = 10
})

function SWEP:CanHeal(owner)
    if (owner:GetNW2Int("head",100) == 100
    and owner:GetNW2Int("chest",100) == 100
    and owner:GetNW2Int("arms",100) == 100
    and owner:GetNW2Int("legs",100) == 100
    and owner:Health() >= owner:GetMaxHealth()
    and owner:GetBleeding() == 0) then return false end
    return true
end

function SWEP:Heal(ply)
    ply:SetHealth(math.min(ply:Health() + LUCTUS_MEDIC_BANDAGE_HEAL_HP, ply:GetMaxHealth()))
    ply:SetNW2Int("head",math.min(ply:GetNW2Int("head",100) + (LUCTUS_MEDIC_BANDAGE_HEAL_LIMBS), 100))
    ply:SetNW2Int("chest",math.min(ply:GetNW2Int("chest",100) + (LUCTUS_MEDIC_BANDAGE_HEAL_LIMBS), 100))
    ply:SetNW2Int("arms",math.min(ply:GetNW2Int("arms",100) + (LUCTUS_MEDIC_BANDAGE_HEAL_LIMBS), 100))
    ply:SetNW2Int("legs",math.min(ply:GetNW2Int("legs",100) + (LUCTUS_MEDIC_BANDAGE_HEAL_LIMBS), 100))
    ply:AddBleeding(-LUCTUS_MEDIC_BANDAGE_HEAL_BLEED)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() or self.Busy then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    if not self:CanHeal(owner) then return end

    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Busy = true


    timer.Simple(self:SequenceDuration() * 0.9, function()
        self:Heal(owner)
        self:TakePrimaryAmmo(1)
    end)

    timer.Simple(self:SequenceDuration() + 0.5, function()
        self.Busy = false
        if not IsValid(owner) then return end
        if owner:GetAmmoCount("ammo_bandage") <= 0 then
            if SERVER then
                self:Remove()
            else
                RunConsoleCommand("lastinv")
            end
        else
            self:SendWeaponAnim(ACT_VM_DRAW)
        end
    end)

    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
    local tr = util.QuickTrace(self.Owner:GetShootPos(), self.Owner:GetAimVector() * 96, self.Owner)
    if not IsFirstTimePredicted() or not tr.Entity:IsPlayer() or self.Busy then return end
    local target = tr.Entity

    if not self:CanHeal(target) then return end
    
    self:EmitSound("physics/wood/wood_strain2.wav")
    timer.Simple(0.6, function()
        self:EmitSound("flesh_scrapple")
        timer.Simple(0.8, function()
            self:StopSound("flesh_scrapple")
        end)
    end)
    self.Busy = true
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    timer.Simple(self:SequenceDuration() * 0.9, function()
        self:Heal(target)
        self:TakePrimaryAmmo(1)
    end)

    local owner = self:GetOwner()
    timer.Simple(self:SequenceDuration() + 0.5, function()
        self.Busy = false
        if not IsValid(owner) then return end
        if owner:GetAmmoCount("ammo_bandage") <= 0 then
            if SERVER then
                self:Remove()
            else
                RunConsoleCommand("lastinv")
            end
        else
            self:SendWeaponAnim(ACT_VM_DRAW)
        end
    end)

    self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Think()end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    return true
end

if SERVER then return end

local bleed = surface.GetTextureID("ggui/bleed")
local grp = {"head","chest","arms","legs"}
local color_green = Color(105,250,100)
local color_white = Color(255,255,255)
function SWEP:DrawHUD()
    local target = self.Owner:GetEyeTrace().Entity
    if not IsValid(target) then return end
    if not target:IsPlayer() then return end

    if target:IsBleeding() then
        surface.SetDrawColor(color_white)
        surface.SetTexture(bleed)
        surface.DrawTexturedRectRotated(ScrW() / 2 + 272, ScrH() / 2 - 48, 128, 128, 0)
        draw.SimpleText(" <!> BLEEDING <!> ", "Trebuchet18", ScrW() / 2 + 272, ScrH() / 2 - 28, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if LUCTUS_MEDIC_DAMAGE_ENABLED then
        local x, y, w = ScrW() / 1.8, ScrH() / 2.3, 128
        for k,name in pairs(grp) do
            draw.SimpleText(name, "Trebuchet18", x, y - 20 + (k - 1) * 36, color_white)
            draw.RoundedBox(0,x, y + (k - 1) * 36, w - 14, 12,color_white)
            draw.RoundedBox(0, x + 2, y + (k - 1) * 36 + 2, (w - 18) * (target:GetNW2Int(name,100) / 100), 8, color_green)
        end
    end
end

function SWEP:GetViewModelPosition( pos, ang )
    return pos + Vector(0,0,-8), ang + Angle(-16,0,0)
end
