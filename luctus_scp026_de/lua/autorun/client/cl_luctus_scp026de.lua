--Luctus SCP 026 DE
--Made by OverlordAkise

LUCTUS_SCP026DE_INFECTED = LUCTUS_SCP026DE_INFECTED or {}

net.Receive("luctus_scp026de",function()
    local ply = net.ReadEntity()
    if not ply or not IsValid(ply) then
        print("[luctus_scp026de] WARNING: Invalid player received!")
        return
    end
    local hasBeenInfected = net.ReadBool()
    local me = LocalPlayer()
    if ply == me then
        LuctusSCP026DEShowInfected(hasBeenInfected)
    end
    if team.GetName(me:Team()) == LUCTUS_SCP026DE_JOBNAME then
        LuctusSCP026DEAddToList(ply,hasBeenInfected)
    end
end)

local IAMINFECTED = false
local DEATHTIME = 0
function LuctusSCP026DEShowInfected(hasBeenInfected)
    if hasBeenInfected then
        surface.PlaySound("ambient/levels/canals/windchime2.wav")
        IAMINFECTED = true
        DEATHTIME = CurTime()+LUCTUS_SCP026DE_DEATH_TIMER
        notification.AddLegacy("You have been infected by SCP-026-DE",0,5)
    else
        IAMINFECTED = false
        surface.PlaySound("player/suit_sprint.wav")
    end
end

local color_darker = Color(0,0,0,220)
hook.Add("HUDPaint","luctus_scp026de",function()
    if LocalPlayer():GetNW2Bool("scp026de_visoron",false) then
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),color_darker)
    end
    if not IAMINFECTED then return end
    draw.SimpleTextOutlined(string.FormattedTime(DEATHTIME-CurTime(),"%02i:%02i"),"Trebuchet24",ScrW()/2,ScrH()/2-100,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,color_black)
end)

function LuctusSCP026DEAddToList(ply,hasBeenInfected)
    if hasBeenInfected then
        LUCTUS_SCP026DE_INFECTED[ply] = CurTime()
        surface.PlaySound("ambient/levels/canals/windchime2.wav")
        notification.AddLegacy(ply:Nick().." is now infected by you", 0, 3)
    else
        LUCTUS_SCP026DE_INFECTED[ply] = nil
        surface.PlaySound("ambient/levels/canals/windchime5.wav")
        notification.AddLegacy(ply:Nick().." has been freed from your grasp", 0, 3)
    end
end

local model = ClientsideModel("models/props_phx/construct/glass/glass_curve90x1.mdl")
model:SetNoDraw(true)
hook.Add( "PostPlayerDraw" , "luctus_scp035_mask" , function( ply )
    if ply:GetNW2Bool("scp026de_visoron",false) then
        if not IsValid(ply) or not ply:Alive() then return end

        local attach_id = ply:LookupAttachment('eyes')
        if not attach_id then return end

        local attach = ply:GetAttachment(attach_id)

        if not attach then return end

        local pos = attach.Pos
        local ang = attach.Ang

        model:SetModelScale(0.15, 0)
        pos = pos + (ang:Forward() *1.5)
        pos = pos + (ang:Up() *(4))
        ang:RotateAroundAxis(ang:Right(), 180)
        ang:RotateAroundAxis(ang:Up(), -45)

        model:SetPos(pos)
        model:SetAngles(ang)

        model:SetRenderOrigin(pos)
        model:SetRenderAngles(ang)
        model:SetupBones()
        model:DrawModel()
        model:SetRenderOrigin()
        model:SetRenderAngles()

    end 
end)

print("[luctus_scp026de] cl loaded")
