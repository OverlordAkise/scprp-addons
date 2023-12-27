--Luctus SCP106
--Made by OverlordAkise

AddCSLuaFile()

SWEP.PrintName = "SCP 106"
SWEP.Author = "OverlordAkise"
SWEP.Purpose = "Become SCP106"
SWEP.Instructions = "Press LMB to shoot an orb, RMB to teleport someone to the shadow realm and Reload to teleport yourself"
SWEP.Category = "SCP"
SWEP.Sound = ""

SWEP.ViewModel = ""
SWEP.WorldModel = "models/effects/combineball.mdl"
SWEP.UseHands = true
SWEP.ViewModelFOV = 54
--SWEP.ViewModelFlip = false

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.HoldType = "normal"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
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


function SWEP:Deploy()
    return true
end

function SWEP:DrawWorldModel()
    if not self.isCharging then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then
        self:DrawModel(flags)
        return
    end
    local bi = self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand")
    if not bi then return end
    local bpos,bang = self:GetOwner():GetBonePosition(bi)
    self:SetRenderOrigin(bpos)
    self:DrawModel()
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Holster()
    return true
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    if not IsValid(self:GetOwner()) then return end
    local owner = self:GetOwner()
    self:SetNextPrimaryFire(CurTime()+LUCTUS_SCP106_ATTACK_DELAY)
    self:SetHoldType("magic")
    self.isCharging = true
    self:EmitSound("weapons/cguard/charging.wav",40,100)
    timer.Simple(LUCTUS_SCP106_ATTACK_CHARGETIME,function()
        if not IsValid(self) then return end
        self:SetHoldType("normal")
        self.isCharging = false
        if not IsValid(owner) then return end
        self:EmitSound("npc/vort/attack_shoot.wav",40,150)
        if CLIENT then return end
        LuctusSCP106CreateOrbAndLaunch(owner)
    end)
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + LUCTUS_SCP106_ALTATTACK_COOLDOWN)
    if CLIENT then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    local trace = owner:GetEyeTrace()
    local ent = trace.Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end
    
    local pos,name = table.Random(LUCTUS_SCP106_TP_POINTS)
    DarkRP.notify(owner,0,5,"Teleported player to "..name)
    LuctusSCP106Teleport(ent,pos)
end

SWEP.lastReload = 0
SWEP.lastTeleport = 0
local reload_toggle_delay = 1

function SWEP:Reload()
    if self.lastTeleport > CurTime() then return end
    if self.lastReload > CurTime() then return end
    self.lastReload = CurTime()+reload_toggle_delay
    if SERVER then return end
    
    local activeButton = nil
    
    local frame = vgui.Create("DFrame")
    frame:SetSize(900,600)
    frame:SetTitle("SCP106 | Teleportation")
    frame:Center()
    frame:MakePopup()
    function frame:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0, 195, 165))
        draw.RoundedBox(0,1,1,w-2,h-2,Color(20,20,20,255))
    end
    
    local scroll = vgui.Create("DScrollPanel",frame)
    scroll:Dock(LEFT)
    scroll:SetWide(200)
    scroll:DockMargin(0,5,10,5)
    
    local rpanel = vgui.Create("DPanel",frame)
    rpanel:Dock(FILL)
    rpanel.pos = LocalPlayer():GetPos()+Vector(0,0,64)
    rpanel.ang = LocalPlayer():GetAngles()
    rpanel.name = ""
    function rpanel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(10,50,100))
        local x,y = self:LocalToScreen()
        local old = DisableClipping(true)
        render.RenderView({
            origin = self.pos,
            angles = self.ang,
            x = x,
            y = y,
            w = w,
            h = h,
        })
        DisableClipping(old)
    end
    
    local tpbutton = vgui.Create("DButton",frame)
    tpbutton:Dock(BOTTOM)
    tpbutton:SetHeight(60)
    tpbutton:DockMargin(0,5,0,5)
    tpbutton:SetFont("Trebuchet24")
    tpbutton:SetText("Select a destination!")
    tpbutton.DoClick = function(s)
        if rpanel.name == "" then return end
        net.Start("luctus_scp106_tp")
            net.WriteString(rpanel.name)
        net.SendToServer()
        self.lastTeleport = CurTime()+LUCTUS_SCP106_TELEPORT_COOLDOWN
        frame:Close()
    end
    LuctusSCP106BeautifyButton(tpbutton)
    
    local t = table.Copy(LUCTUS_SCP106_TP_POINTS)
    if self.LastTP then
        t["last"] = self.LastTP
    end
    for name,pos in pairs(t) do
        local button = scroll:Add("DButton")
        button:SetText(name)
        button:Dock(TOP)
        button:SetFont("Trebuchet18")
        button:DockMargin(0,0,0,5)
        button:SetHeight(50)
        button.pos = pos
        button.name = name
        --Design:
        LuctusSCP106BeautifyButton(button)
        function button:DoClick()
            surface.PlaySound("UI/buttonclick.wav")
            rpanel.pos = pos+Vector(0,0,64)
            rpanel.name = self.name
            tpbutton:SetText("Teleport to "..self.name)
            activeButton = self
        end
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
    local cdrel = self.lastTeleport-CurTime()
    if cdlmb > 0 and LUCTUS_SCP106_ATTACK_DELAY > 0.8 then
        draw.SimpleTextOutlined("(LBM) Attack", "Trebuchet24", scrw-100, scrh/1.3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+1,(cdlmb*200)/LUCTUS_SCP106_ATTACK_DELAY-2,24-2,color_white)
    end
    if cdrmb > 0 then
        draw.SimpleTextOutlined("(RMB) Shadow-Realm'er", "Trebuchet24", scrw-100, scrh/1.3+30, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+30,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+30+1,(cdrmb*200)/LUCTUS_SCP106_ALTATTACK_COOLDOWN-2,24-2,color_white)
    end
    if cdrel > 0 then
        draw.SimpleTextOutlined("(Reload) Teleport", "Trebuchet24", scrw-100, scrh/1.3+60, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        draw.RoundedBox(0,scrw-95,scrh/1.3+60,200,24,color_black)
        draw.RoundedBox(0,scrw-95+1,scrh/1.3+60+1,(cdrel*200)/LUCTUS_SCP106_TELEPORT_COOLDOWN-2,24-2,color_white)
    end
end
