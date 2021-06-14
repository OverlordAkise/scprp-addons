AddCSLuaFile()

scp049_colors = {
  ["Red"] = {1,Color(255,0,0)},
  ["Green"] = {2,Color(0,255,0)},
  ["Blue"] = {3,Color(0,0,255)},
  ["Yellow"] = {4,Color(255,215,0)},
  ["Purple"] = {5,Color(128,0,128)},
  ["Cyan"] = {6,Color(0,255,255)},
  ["Grey"] = {7,Color(211,211,211)},
}

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
DEFINE_BASECLASS("weapon_cs_base2")

SWEP.PrintName = "SCP049 Weapon"
SWEP.Author = "OverlordAkise"
SWEP.Instructions = "Left click to kill, right click to break open doors"
SWEP.Contact = "@OverlordAkise on Steam"
SWEP.Purpose = "SCP049"
SWEP.IsDarkRPDoorRam = true

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.AnimPrefix = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "SCP"

SWEP.Sound = "physics/wood/wood_box_impact_hard3.wav"

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
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

function SWEP:SecondaryAttack()
  if not IsFirstTimePredicted() then return end
  local Owner = self:GetOwner()

  if not IsValid(Owner) then return end

  self:SetNextPrimaryFire(CurTime() + 0.1)
  if CLIENT then
    local col1 = nil
    local col2 = nil
    local sel1 = nil
    local sel2 = nil
    local window = vgui.Create("DFrame")
    window:SetTitle("Mix Medicine")
    window:SetSize(600,400)
    window:Center()
    window:MakePopup()
    local saveButton = vgui.Create("DButton",window)
    saveButton:SetText("MIX!")
    saveButton:Dock(BOTTOM)
    function saveButton:DoClick()
      if col1 and col2 then
        net.Start("luctus_scp049_mixing")
          net.WriteInt(col1,17)
          net.WriteInt(col2,17)
        net.SendToServer()
        window:Close()
      end
    end
    local list1 = vgui.Create("DPanel",window)
    list1:Dock(LEFT)
    list1:SetSize(290,400)
    list1:SetPaintBackground(false)
    local list2 = vgui.Create("DPanel",window)
    list2:Dock(RIGHT)
    list2:SetSize(290,400)
    list2:SetPaintBackground(false)
    local button = vgui.Create("DButton",list1)
    button:SetText("First Mixture")
    button:Dock(TOP)
    button = vgui.Create("DButton",list2)
    button:SetText("Second Mixture")
    button:Dock(TOP)
    for k,v in pairs(scp049_colors) do
      button = vgui.Create("DButton",list1)
      button:Dock(TOP)
      button:SetText(k)
      button.selected = false
      button.col = v[2]
      button.id = v[1]
      function button:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,self.col)
        if sel1 == self then
          surface.SetDrawColor(0,0,0,255)
          surface.DrawOutlinedRect(0, 0, w, h, 3)
        end
      end
      function button:DoClick()
        col1 = self.id
        sel1 = self
      end
    end
    for k,v in pairs(scp049_colors) do
      button = vgui.Create("DButton",list2)
      button:Dock(TOP)
      button:SetText(k)
      button.selected = false
      button.col = v[2]
      button.id = v[1]
      function button:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,self.col)
        if sel2 == self then
          surface.SetDrawColor(0,0,0,255)
          surface.DrawOutlinedRect(0, 0, w, h, 3)
        end
      end
      function button:DoClick()
        col2 = self.id
        sel2 = self
      end
    end
  end
end

function SWEP:PrimaryAttack()
  if not IsValid(self:GetOwner()) then return end
  self:SetNextPrimaryFire(CurTime()+10)
  self:GetOwner():LagCompensation(true)

  local spos = self:GetOwner():GetShootPos()
  local sdest = spos + (self:GetOwner():GetAimVector() * 70)

  local kmins = Vector(1,1,1) * -10
  local kmaxs = Vector(1,1,1) * 10

  local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

  -- Hull might hit environment stuff that line does not hit
  if not IsValid(tr.Entity) then
    tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
  end

  local hitEnt = tr.Entity

  -- effects
  if IsValid(hitEnt) then
    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

    local edata = EffectData()
    edata:SetStart(spos)
    edata:SetOrigin(tr.HitPos)
    edata:SetNormal(tr.Normal)
    edata:SetEntity(hitEnt)

    if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
       util.Effect("BloodImpact", edata)
    end
  else
    self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
  end

  if SERVER then
    self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
  end


  if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
    if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
      local owner = player.GetAll()[2]--hitEnt:GetRagdollOwner()
      local mixedFunc = scp049_effect_functions[scp049_mixtable[scp049_col_one][scp049_col_two]]
      self.Owner:PrintMessage(HUD_PRINTTALK, "Your mixture was '"..scp049_mixtable[scp049_col_one][scp049_col_two].."'")
      mixedFunc(owner)
    end
  end

  self:GetOwner():LagCompensation(false)
end
