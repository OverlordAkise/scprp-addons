--Luctus SCP096 System
--Made by OverlordAkise

local red_material = CreateMaterial("luctus_red", "VertexLitGeneric", { ["$basetexture"] = "models/debug/debugwhite", ["$model"] = 1, ["$ignorez"] = 1 })

local col = Color(255,0,0,255)

scp096_hunted_players = {}

net.Receive("luctus_scp096_update",function()
    scp096_hunted_players = net.ReadTable()
end)

hook.Add("OnPlayerChangedTeam", "luctus_scp096_hunters_update", function(ply, before, after)
    if string.EndsWith(RPExtraTeams[before].name,"096") then
        scp096_hunted_players = {}
    end
end)

--Code for highlighting player in a halo (around body)
hook.Add("PreDrawHalos", "luctus_scp096_halo", function()
    halo.Add( scp096_hunted_players, col, 1, 1, 5, true, true )
end)

--dark screen if bag is on
local color_dark = Color(0,0,0,240)
local color_darkred = Color(200,0,0,10)
hook.Add("HUDPaint", "luctus_scp096_bagdarkener", function()
    if LocalPlayer():GetNWBool("scp096_bag",false) then
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),color_dark)
        draw.SimpleTextOutlined("You have a bag over your head!", "DermaLarge", ScrW()*0.5, ScrH()*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 5, color_black)
    end
    if #scp096_hunted_players > 0 then
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),color_darkred)
        draw.SimpleTextOutlined("RAGE", "DermaLarge", ScrW()*0.5, ScrH()*0.8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end
end)

--Code for highlighting the player in red (inside body)
hook.Add("RenderScreenspaceEffects", "luctus_scp096_glow", function()
    for k,v in pairs(scp096_hunted_players) do
        cam.Start3D(EyePos(), EyeAngles())

            cam.IgnoreZ(true)
            render.MaterialOverride(red_material)
            render.SuppressEngineLighting(true)
            render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
            render.SetBlend(0.7)
            v:DrawModel()
            render.SuppressEngineLighting(false)
            render.MaterialOverride()
            cam.IgnoreZ(false)

        cam.End3D()
    end
end)


if BAGMODEL then BAGMODEL:Remove() end
BAGMODEL = ClientsideModel( "models/props_junk/garbage_bag001a.mdl" )
BAGMODEL:SetNoDraw(true)

hook.Add( "PostPlayerDraw" , "luctus_scp096_bag" , function( ply )
    if ply:GetNWBool("scp096_bag",false) and ply ~= LocalPlayer() then
        if not IsValid(ply) or not ply:Alive() then return end

        local attach_id = ply:LookupAttachment('mouth')
        if not attach_id then return end
          
        local attach = ply:GetAttachment(attach_id)
          
        if not attach then return end
          
        local pos = attach.Pos
        local ang = attach.Ang

        BAGMODEL:SetModelScale(1.3, 0)
        pos = pos + (ang:Forward() *-2.6)
        pos = pos + (ang:Up() *(-4))
        ang:RotateAroundAxis(ang:Right(), 270)
        ang:RotateAroundAxis(ang:Up(), 180)

        BAGMODEL:SetPos(pos)
        BAGMODEL:SetAngles(ang)

        BAGMODEL:SetRenderOrigin(pos)
        BAGMODEL:SetRenderAngles(ang)
        BAGMODEL:SetupBones()
        BAGMODEL:DrawModel()
        BAGMODEL:SetRenderOrigin()
        BAGMODEL:SetRenderAngles()
    end    
end)

print("[SCP096] CL loaded!")
