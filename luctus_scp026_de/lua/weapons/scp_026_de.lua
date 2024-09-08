--Luctus SCP-026-DE SWEP
--Made by OverlordAkise

AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "SCP-026-DE Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Rightclick to judge players, Leftclick to turn them towards you"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP173"

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.AnimPrefix = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "SCP"

SWEP.IsTransformed = false
SWEP.TransformModel = ""
--currently random metal stress
SWEP.CopySound = "physics/wood/wood_box_impact_hard3.wav" 

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

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + 0.3)
    if SERVER then return end
    if SERVER then return end
    if IsValid(self.window) then return end
    self.window = vgui.Create("DFrame")
    self.window:SetTitle("SCP-026-DE")
    self.window:SetSize(400,300)
    self.window:ShowCloseButton(false)
    self.window:Center()
    self.window:MakePopup()
    function self.window:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
  
    local closeButton = vgui.Create("DButton",self.window)
    closeButton:SetPos(400-32,2)
    closeButton:SetSize(30,20)
    closeButton:SetText("X")
    closeButton:SetTextColor( Color(255,0,0) )
    closeButton.DoClick = function(s)
        self.window:Close()
    end
    function closeButton:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if self.Hovered then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
  
    local helpText = nil
    local text = {"Tell the infected a question in rhyme","Wrong answer means death in very short time"}
    for k,v in pairs(text) do
        helpText = vgui.Create("DLabel",self.window)
        helpText:SetFont("Trebuchet18")
        helpText:SetText(v)
        helpText:SetTextColor(Color(0,195,165))
        helpText:SetContentAlignment(5)
        helpText:DockMargin(1,1,1,1)
        helpText:Dock(TOP)
    end

    local DScrollPanel = vgui.Create( "DScrollPanel", self.window )
    DScrollPanel:Dock(FILL)

    for ply,starttime in pairs(LUCTUS_SCP026DE_INFECTED) do
        if not IsValid(ply) then continue end
        local zonebutton = DScrollPanel:Add("DButton")
        zonebutton.ply = ply
        zonebutton.plynick = ply:Nick()
        zonebutton:SetText(ply:Nick().." // "..string.NiceTime(starttime+LUCTUS_SCP026DE_DEATH_TIMER-CurTime()))
        zonebutton.st = starttime
        zonebutton:DockMargin(1,1,1,1)
        zonebutton:SetTextColor(color_white)
        zonebutton:Dock(TOP)
        zonebutton:SetContentAlignment(5) --middle-left
        function zonebutton:Think()
            self:SetText(self.plynick.." // "..string.NiceTime(self.st+LUCTUS_SCP026DE_DEATH_TIMER-CurTime()))
        end
        zonebutton.DoClick = function(s)
            local menu = DermaMenu() 
            menu:AddOption("Spare",function()
                net.Start("luctus_scp026de")
                    net.WriteEntity(s.ply)
                    net.WriteBool(false)
                net.SendToServer()
                self.window:Close()
            end):SetIcon("icon16/flag_green.png")
            menu:AddOption("Tear",function()
                net.Start("luctus_scp026de")
                    net.WriteEntity(s.ply)
                    net.WriteBool(true)
                net.SendToServer()
                self.window:Close()
            end):SetIcon("icon16/cross.png")
            menu:Open()
        end
        function zonebutton:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
            if self.Hovered then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            end
        end
    end
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextSecondaryFire(CurTime() + 0.2)
    if CLIENT then return end
    local ply = self:GetOwner()
    if not IsValid(ply) then return end
    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) then return end
    local targetAng = (ply:EyePos() - ent:GetShootPos()):Angle()
    targetAng.roll = 0
    ent:SetEyeAngles(LerpAngle(LUCTUS_SCP026DE_TURN_SPEED,ent:LocalEyeAngles(),targetAng))
end

SWEP.next_think = 0
local cosRad15 = math.cos(math.rad(15))
function SWEP:Think()
    if CLIENT then return end
    local ply = self:GetOwner()
    if self.next_think > CurTime() then return end
    self.next_think = CurTime() + 0.3
    local plyAimVec = ply:GetAimVector()
    plyAimVec.z = 0
    local eyePos = ply:EyePos()
    local entities_in_view = ents.FindInCone(eyePos-plyAimVec*50, ply:GetAimVector(), 512, cosRad15)
    local myAimVec = ply:GetAimVector()
    for k,v in ipairs(entities_in_view) do
        if not v:IsPlayer() then continue end
        if v == ply then continue end
        local alive = v:Alive()
        if MedConfig then
            alive = not v._IsDead
        end
        if not alive then continue end
        if not ply:IsLineOfSightClear(v) then return end
        if v:GetNW2Bool("scp026de_visoron",false) then continue end
        local a2 = v:GetAimVector():GetNegated()
        if myAimVec:Distance(a2) < 0.9 then
            LuctusSCP026DEActivateTimer(v,true)
        end
    end
end
