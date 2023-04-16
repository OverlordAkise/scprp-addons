--Luctus SCP966 System
--Made by OverlordAkise


--Vision for scp966
hook.Add("OnPlayerChangedTeam","luctus_fullbright_reset", function(ply, beforeNum, afterNum)
    --switch to
    if string.EndsWith(LocalPlayer():getDarkRPVar("job"),"966") then
        RunConsoleCommand("luctus_fullbright","1")
        hook.Add("PreDrawHalos", "luctus_scp966_halo",LuctusSCP966Halo)
    else
        RunConsoleCommand("luctus_fullbright","0")
        flashEnabled = false
        hook.Remove("RenderScreenspaceEffects", "luctus_nv")
        hook.Remove("PreDrawHalos", "luctus_scp966_halo")
        if scp966_ply and IsValid(scp966_ply) then
            scp966_ply:SetNoDraw(true)
        end
    end
end)

--NoDraw SCP966 Stuff here
scp966_ply = scp966_ply or nil
net.Receive("luctus_scp966_nodraw",function()
    scp966_ply = net.ReadEntity()
    if scp966_ply and IsValid(scp966_ply) then
        if not flashEnabled then
            scp966_ply:SetNoDraw(true)
        end
    else
        for k,v in pairs(player.GetAll()) do
            v:SetNoDraw(false)
        end
    end
end)

--Code for highlighting player in a halo (around body)
--TODO: This doesnt work as WalkSpeed is not networked to clients :-(
local red = Color(255,0,0)
local green = Color(0,255,0)
function LuctusSCP966Halo()
    local ply = LocalPlayer():GetEyeTrace().Entity
    if IsValid(ply) and ply:IsPlayer() then
        local speed = ply:GetWalkSpeed()
        halo.Add({ply}, speed > LUCTUS_SCP966_WALKSPEEDNEEDED and red or green , 1, 1, 5, true, true )
    end
end

print("[SCP966] CL loaded!")
