--Luctus SCP HUD
--Made by OverlordAkise

if not LUCTUS_SHUD_OVERHEAD_SHOULDLOAD then return end

hook.Add("InitPostEntity","luctus_shud_overhead_init",function()
    GAMEMODE.Config.showjob = false
    GAMEMODE.Config.showhealth = false
    GAMEMODE.Config.showname = false
end)


local color_white = Color(255,255,255)

function LuctusGetWidth(name,jobname)
    surface.SetFont("Trebuchet24")
    local nameWidth, _ = surface.GetTextSize(name)
    if LUCTUS_SHUD_OVERHEAD_SHOW_JOB then
        surface.SetFont("Trebuchet18")
        local jobWidth, _ = surface.GetTextSize(jobname)
        if jobWidth > nameWidth then return jobWidth end
    end
    return nameWidth
end

hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator")

local margin = 15
local boxHeight = 50
local playersToRender = {}

timer.Create("luctus_shud_overhead_cache",0.2,0,function(  )
    --if not LUCTUS_SHUD_OVERHEAD_SHOULD_DRAW then return end
    playersToRender = {}
    local players = player.GetAll()
    for k,v in pairs(players) do
        if not IsValid(v) then continue end
        if v == LocalPlayer() then continue end
        if LocalPlayer():GetPos():Distance(v:GetPos()) < 256 or v:IsSpeaking() then
            table.insert(playersToRender,v)
        end
    end
end)

--Create the hook to draw the player overhead.
hook.Add("PostDrawTranslucentRenderables","luctus_shud_overhead",function()
    local ply = LocalPlayer()
    for k,v in pairs(playersToRender) do
        if not IsValid(v) then continue end
        if not v:Alive() then continue end
        if v:IsDormant() then continue end
        if v:GetColor().a < 100 or v:GetNoDraw() then continue end

        local eyeAngs = ply:EyeAngles()
        local name = v:Nick()
        local jobname = v:getDarkRPVar("job") or "Unknown"
        local health = v:Health()
        local boxWidth = LuctusGetWidth(name,jobname)+margin*2
        local boxPos = -1*((margin + boxWidth) / 2)
        local eyePos = v:EyePos()
        local scale = LocalPlayer():GetPos():Distance(v:GetPos())*0.0017
        

        local playerHeightOffset = eyePos.z - v:GetPos().z + scale*35

        cam.Start3D2D(Vector(eyePos.x, eyePos.y,v:GetPos().z) + Vector(0,0,math.max(playerHeightOffset + 18, 
        55)),Angle(0,eyeAngs.y - 90,90),scale)
            LuctusDrawEdgeBox(boxPos,0,boxWidth,50)
            if LUCTUS_SHUD_OVERHEAD_SHOW_JOB then
                draw.SimpleText(name,"Trebuchet24",boxPos+margin,2,color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(jobname,"Trebuchet18",boxPos+margin,boxHeight-5,color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            else
                draw.SimpleText(name,"Trebuchet24",boxPos+margin,12,color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        cam.End3D2D()
    end
end)

print("[luctus_hud] overhead loaded!")
