--Luctus SCP173 System
--Made by OverlordAkise

hook.Add("InitPostEntity","luctus_scp173_recinit", function()
    local scpcell = ClientsideModel("models/scp173box/scp173containmentbox.mdl")
    scpcell:SetNoDraw(true)
    hook.Add("PostPlayerDraw","luctus_scp173_drawrecbox", function(ply)
        if not IsValid(ply) or not ply:Alive() or not ply:GetNW2Bool("scp173cell",false) then return end
        scpcell:SetModelScale(0.8, 0) 
        scpcell:SetPos(ply:GetPos())
        scpcell:SetRenderOrigin(ply:GetPos())
        scpcell:SetupBones()
        scpcell:DrawModel()
        scpcell:SetRenderOrigin()
    end)
    print("[SCP173] recbox Loaded!")
end)
