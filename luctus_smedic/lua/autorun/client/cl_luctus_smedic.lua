--Luctus Medic (SCP)
--Made by OverlordAkise


local timeTillRespawn = 0
local timeDeadFor = 0
local grp = {"head","chest","arms","legs"}
local defHeight = 0
local w = 200
local h = 152
local x = 40
local y = 128

local function height(b)
    if not b then defHeight = defHeight + 20 end
    return y+defHeight
end

local uiEnabled = false
hook.Add("HUDPaint","luctus_smedic",function()
    if not uiEnabled then return end
    defHeight = 0

    draw.RoundedBox(0,x-30,y+10,w+60,h+40,Color(0,0,0,90))

    surface.SetDrawColor(color_white)
    for k,name in pairs(grp) do
        draw.SimpleText(name, "Trebuchet18", x, height(), color_white)
        draw.RoundedBox(0,x, height(), w, 20,Color(255,255,255))
        draw.RoundedBox(0,x, height(1), ((LocalPlayer():GetNWInt(name,100)/100)*w), 20,Color(105,250,100))
    end
end)

hook.Add("OnContextMenuOpen", "luctus_smedic_show", function()
    if not LUCTUS_MEDIC_DAMAGE_ENABLED then return end
    uiEnabled = true
end)

hook.Add("OnContextMenuClose", "luctus_smedic_hide", function()
    uiEnabled = false
end)

hook.Add("CreateClientsideRagdoll","luctus_smedic_hideclrag",function(ownEnt,ragEnt)
    if ragEnt:GetClass() == "class C_HL2MPRagdoll" then
        ragEnt:SetNoDraw(true)
    end
end)

--TODO
--NEW START

--TODO: Verify that corpse class matches
local NearbyCorpses = {}
timer.Create("luctus_smedic_close_corpses",0.5,0,function()
    NearbyCorpses = {}
    if not IsValid(LocalPlayer()) then return end
    local own = nil
    if IsValid(LocalPlayer():GetObserverTarget()) then
        own = LocalPlayer():GetObserverTarget()
    end
    for k,ent in pairs(ents.FindInSphere(LocalPlayer():GetPos(),256)) do
        if ent:GetClass() ~= "prop_ragdoll" then continue end --C_HL2MPRagdoll ?
        if ent == own then continue end
        table.insert(NearbyCorpses,ent)
    end
end)

hook.Add("HUDPaint","luctus_smedic_corpses",function()
    for k,ent in pairs(NearbyCorpses) do
        if not IsValid(ent) then continue end
        local pos = ent:GetPos():ToScreen()
        draw.SimpleTextOutlined(ent:GetNWString("state"), "Trebuchet18", pos.x, pos.y-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
        local respawnTime = ent:GetNWString("respawnTime","")
        if not respawnTime or respawnTime == "" then continue end
        draw.SimpleTextOutlined(math.max(0,math.Round(respawnTime-CurTime())), "Trebuchet18", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    end
end)


lDeathscreen = nil
net.Receive("luctus_medic_deathscreen",function()
    local deathTime = net.ReadInt(15)
    local fullyDead = net.ReadBool()
    timeTillRespawn = CurTime()+deathTime
    timeDeadFor = deathTime
    if deathTime < 0 then -- = -1
        timeTillRespawn = 0
        if lDeathscreen and IsValid(lDeathscreen) then
            lDeathscreen:Close()
        end
        return
    end
    if IsValid(lDeathscreen) then lDeathscreen:Close() end
    lDeathscreen = vgui.Create("DFrame")
    lDeathscreen:SetDraggable(false)
    lDeathscreen:ShowCloseButton(false)
    lDeathscreen:SetTitle("")
    lDeathscreen:SetPos(0,0)
    lDeathscreen:SetSize(ScrW(),ScrH())
    lDeathscreen.header = fullyDead and LUCTUS_MEDIC_DEATHSCREEN_DEAD_HEADER or LUCTUS_MEDIC_DEATHSCREEN_BLEEDING_HEADER
    lDeathscreen.body = fullyDead and LUCTUS_MEDIC_DEATHSCREEN_DEAD_BODY or LUCTUS_MEDIC_DEATHSCREEN_BLEEDING_BODY
    function lDeathscreen:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,240))
        draw.DrawText(self.header,"Trebuchet24",ScrW()/2,200,COLOR_WHITE,TEXT_ALIGN_CENTER)
        draw.DrawText(self.body,"Trebuchet18",ScrW()/2,400,COLOR_WHITE,TEXT_ALIGN_CENTER)
        local timeLeft = math.max(0,math.Round(timeTillRespawn-CurTime()))
        if timeLeft == 0 then
            draw.DrawText("Press [LMB] to respawn!","Trebuchet24",ScrW()/2,ScrH()-200,COLOR_WHITE,TEXT_ALIGN_CENTER)
        else
            draw.DrawText("Respawn in "..timeLeft.."s","Trebuchet24",ScrW()/2,ScrH()-200,COLOR_WHITE,TEXT_ALIGN_CENTER)
        end
        
    end
end)


local tab = {
    ["$pp_colour_brightness"] = -0.04,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1
}
hook.Add("RenderScreenspaceEffects","luctus_smedic_deathblur", function()
    local p = LocalPlayer()
    if timeTillRespawn > 0 then
        local time = timeTillRespawn - CurTime()
        if time <= 0 then return end
        local power = math.min(1 - (time / timeDeadFor), 1)
        tab["$pp_colour_brightness"] = -power ^ 1.2
        tab["$pp_colour_colour"] = (1-power)
        DrawColorModify(tab)
        DrawMotionBlur(0.1, 5*power, 0.01*power*4)
    end
end)

local bleed = surface.GetTextureID("ggui/bleed")

hook.Add("HUDPaint", "luctus_smedic_bleeding", function()
    if not LUCTUS_MEDIC_BLEEDING_ENABLED then return end
    local p = LocalPlayer()
    if p:IsBleeding() then
        if LUCTUS_MEDIC_BLEEDING_SCREEN then
            surface.SetDrawColor(255, 0, 0,10 + math.cos(RealTime() * 2) * 10)
            surface.DrawRect(0,0,ScrW(),ScrH())
        end
        surface.SetTexture(bleed)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(64, ScrH() / 2, 128 * 1, 128 * 1, 0)
        local alp = math.abs(math.cos(RealTime() * 4) * 75)
        draw.SimpleText("bleeding", "Trebuchet24", 64, ScrH() / 2 + 118, Color(255,125 - alp,125 - alp, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

--TODO: Find out where _hurtBlur is coming from
hook.Add("GetMotionBlurValues", "luctus_smedic_hurt_head", function(h,v,f,r)
    if not LUCTUS_MEDIC_DAMAGE_ENABLED then return end
    local p = LocalPlayer()
    local head = p:GetNWInt("head",100)
    if (head < 70) then
        local per = ((70-head) / 100) * LUCTUS_MEDIC_DAMAGE_HEAD

        if (p._hurtBlur) then
            p._hurtBlur = Lerp(FrameTime(), p._hurtBlur, 0.5)
            if (p._hurtBlur <= 0) then
                p._hurtBlur = 0
            end
        end

        return math.cos(RealTime()) * per / 8, math.sin(RealTime()) * per  * per / 8, math.sin(RealTime()) * per / 2 + (p._hurtBlur or 0), 0
    end
    if (p._hurtBlur) then
        p._hurtBlur = Lerp(FrameTime() * 2, p._hurtBlur, -1)
        if (p._hurtBlur <= 0) then
            p._hurtBlur = nil
            return
        end
        return 0,0,p._hurtBlur,0
    end
end)

--NEW END

print("[luctus_smedic] cl loaded")
