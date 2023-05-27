--Luctus SCP035 System
--Made by OverlordAkise

local model = ClientsideModel("models/vinrax/props/scp035/035_mask.mdl")
model:SetNoDraw( true )

hook.Add( "PostPlayerDraw" , "luctus_scp035_mask" , function( ply )
    if ply:GetNWBool("isSCP035",false) then
        if not IsValid(ply) or not ply:Alive() then return end

        local attach_id = ply:LookupAttachment('eyes')
        if not attach_id then return end

        local attach = ply:GetAttachment(attach_id)

        if not attach then return end

        local pos = attach.Pos
        local ang = attach.Ang

        model:SetModelScale(1, 0)
        pos = pos + (ang:Forward() *1.4)
        pos = pos + (ang:Up() *(-1))
        ang:RotateAroundAxis(ang:Right(), 270)
        ang:RotateAroundAxis(ang:Up(), 90)

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

timer.Create("luctus_scp035_proximitycheck",1,0,function()
    if not IsValid(LocalPlayer()) then return end
    local tEnts = ents.FindByClass("scp035_mask")[1]
    if not IsValid(tEnts) then return end
    if LocalPlayer():IsLineOfSightClear(tEnts) and tEnts:GetPos():Distance(LocalPlayer():GetPos()) < 512 then
        hook.Add("CreateMove","luctus_scp035",LuctusSCP035Angles)
    else
        hook.Remove("CreateMove","luctus_scp035")
    end
end)

function LuctusSCP035Angles(ccmd, x, y, angle)
    local tEnt = ents.FindByClass("scp035_mask")[1]
    if not IsValid(tEnt) then return end
    local targetAng = tEnt:GetPos() - LocalPlayer():GetShootPos()
    targetAng = targetAng:Angle()
    targetAng:Normalize()
    targetAng = Angle(targetAng.p, targetAng.y, 0)
    local newAng = LerpAngle(0.05,LocalPlayer():EyeAngles(),targetAng)
    newAng.r = 0
    ccmd:SetViewAngles(newAng)
end

print("[SCP035] cl loaded!")
