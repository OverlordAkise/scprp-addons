--Luctus SCP999
--Made by OverlordAkise

net.Receive("luctus_scp999_hearts",function()
    local scpPly = net.ReadEntity()
    if not IsValid(scpPly) or scpPly:GetPos():Distance(LocalPlayer():GetPos()) > 2048 then return end
    local pos = scpPly:GetPos()+Vector(0,0,40)
    local emitter = ParticleEmitter(pos, false)
    local mat = Material("icon16/heart.png")
    for i=0,100 do
        local particle = emitter:Add( mat, pos + Vector(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)))
        if particle then
            particle:SetDieTime( 2 )
            particle:SetStartAlpha( 100 )
            particle:SetEndAlpha( 0 )
            particle:SetStartSize( 1 )
            particle:SetEndSize( 1 )
            particle:SetColor(255, 0, 0)
            particle:SetGravity(Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-20, 20)))
        end
    end
    emitter:Finish()
end)

print("[scp999] cl loaded")
