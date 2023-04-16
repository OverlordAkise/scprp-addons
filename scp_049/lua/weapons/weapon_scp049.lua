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

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

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
SWEP.AdminOnly = false
SWEP.Category = "SCP"

SWEP.Sound = "ambient/materials/metal_big_impact_scrape1.wav"
SWEP.KillSound = "player/pl_pain7.wav"

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
    if SERVER then return end
  
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

function SWEP:TouchKill(owner,target,tr)
    if SCP049_SAVE_PMODELS[target:GetModel()] then return end
    local edata = EffectData()
    edata:SetStart(owner:GetShootPos())
    edata:SetOrigin(tr.HitPos)
    edata:SetNormal(tr.Normal)
    edata:SetEntity(target)
    util.Effect("BloodImpact", edata)
    if CLIENT then return end
    target:TakeDamage(99996, owner, self)
    owner:EmitSound(self.KillSound)
end

function SWEP:OpenDoor(ply,ent,trace)
    if CLIENT then return end
    if hook.Call("canDoorRam", nil, ply, trace, ent) ~= nil then return end
    
    if SCP049_UNBREACHABLE[trace.Entity:GetName()] or SCP049_UNBREACHABLE[trace.Entity:MapCreationID()] then
        DarkRP.notify(ply,1,5,"Please use '!breach' to initiate a breach!")
        return false
    end
    
    --SCP doors:
    if ent:GetClass() == "prop_dynamic" and ent:GetParent() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_door" then
        ent = ent:GetParent()
    end
    ent:keysUnLock()
    ent:Fire("open", "", 3)
    ent:Fire("setanimation", "open", 3)
    
    hook.Run("onDoorRamUsed", true, ply, trace)
    ply:EmitSound(self.Sound)
end

function SWEP:PrimaryAttack()
    if not IsValid(self:GetOwner()) then return end
    self:SetNextPrimaryFire(CurTime()+0.2)
    local ply = self:GetOwner()
    local trace = ply:GetEyeTrace()
    if ply:EyePos():Distance(trace.HitPos) > 512 then return end
    local ent = trace.Entity
    if not IsValid(ent) then return end
    
    --Kill Player
    if ent:IsPlayer() and ent:Alive() then
        self:TouchKill(ply,ent,trace)
        return
    end
    --Open Door
    if ent:isDoor() then
        self:OpenDoor(ply,ent,trace)
        return
    end
    --Zombify
    if ent:GetClass() == "prop_ragdoll" and SERVER then
        if not ply.scp049_col_one or not ply.scp049_col_two then return end
        local deadPlayer = ent:GetRagdollOwner()
        --if gDeathsystem:
        if MedConfig then
            local ragdoll = ent
            for k,v in pairs(player.GetAll()) do
                if v:GetNW2Entity("RagdollEntity",nil) == ragdoll then
                    deadPlayer = v
                end
            end
        end
        
        print("[DEBUG]",ply.scp049_col_one,ply.scp049_col_two,scp049_mixtable[ply.scp049_col_one][ply.scp049_col_two])
        local mixName = scp049_mixtable[ply.scp049_col_one][ply.scp049_col_two]
        local mixedFunc = scp049_effect_functions[mixName]
        ply:PrintMessage(HUD_PRINTTALK, "Your mixture was '"..mixName.."'")
        LuctusSCP049SpawnZombie(mixedFunc,deadPlayer,mixName)
    end
end
