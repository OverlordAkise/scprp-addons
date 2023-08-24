--Luctus Cleaner
--Made by OverlordAkise

AddCSLuaFile()

SWEP.Author      = "OverlordAkise"
SWEP.Instructions  = "Create trash spots"

SWEP.Spawnable      = true
SWEP.AdminOnly      = true
SWEP.UseHands      = true
SWEP.Category       = "Cleaner"

SWEP.ViewModel      = "models/weapons/c_pistol.mdl"
SWEP.WorldModel     = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip  = -1
SWEP.Primary.Automatic    = false
SWEP.Primary.Ammo      = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic  = false
SWEP.Secondary.Ammo      = "none"

SWEP.AutoSwitchTo      = false
SWEP.AutoSwitchFrom      = false

SWEP.PrintName        = "Trash Spawner"
SWEP.Slot          = 0
SWEP.SlotPos        = 1
SWEP.DrawAmmo        = false

SWEP.ReloadDelay = 0

function SWEP:Initialize()
    self:SetHoldType("pistol")
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:OnRemove()
    return true
end

function SWEP:Reload()
    if CLIENT then return end
    if self.ReloadDelay > CurTime() then return end
    self.ReloadDelay = CurTime()+0.5
    local trace = self:GetOwner():GetEyeTrace()
    local tab = self:GetOwner():GetTool("permaprops")
    if not tab then return end
    local func = tab.RightClick
    func(self,trace)
end

function SWEP:Think() end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    local sent = ents.Create("luctus_trash")
    --sent:SetModel( "models/dav0r/buttons/button.mdl" )
    sent:SetPos(self:GetOwner():GetEyeTrace().HitPos+Vector(0,0,10))
    sent:Spawn()
    sent.IsHidden = false
    sent:SetNoDraw(false)
    undo.Create("prop")
        undo.AddEntity(sent)
        undo.SetPlayer(self:GetOwner())
    undo.Finish()
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    local trace = self:GetOwner():GetEyeTrace()
    local tab = self:GetOwner():GetTool("permaprops")
    if not tab then return end
    local func = tab.LeftClick
    func(self,trace)
end

function SWEP:FireAnimationEvent(event)
   return true
end

if SERVER then return end

function SWEP:DrawHUD()
    draw.SimpleTextOutlined("Leftclick = place trash spawner", "DermaLarge", 10, ScrH()/2.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
    draw.SimpleTextOutlined("Rightclick = PermaProp (if installed)", "DermaLarge", 10, ScrH()/2.5+40, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
    draw.SimpleTextOutlined("Reload = Un-PermaProp (if installed)", "DermaLarge", 10, ScrH()/2.5+80, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
    for k,v in ipairs(ents.FindByClass("luctus_trash")) do
        local vec = v:GetPos():ToScreen()
        if not vec.visible then continue end
        draw.SimpleTextOutlined("X", "DermaLarge", vec.x, vec.y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
    end
end
